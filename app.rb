require 'sinatra/base'
require 'json'

class App < Monster::Controller
  enable :static
  set :root, File.expand_path('..', __FILE__)

  get '/' do
    [
      '<!doctype html><html><body><pre>',
      Rack::Utils.escape_html(File.read(__FILE__)),
     '</pre></body></html>'
    ].join
  end

  post '/user/login' do
    content_type :json
    {
      status: :ok,
      user_id: params[:user_id]
    }.to_json
  end

  get '/user/:user_id/achievements', provides: :json do
    captures = Repos::Captures.find(user: params[:user_id])

    achieved = captures.map(&:monster)
    pending = ('01'..'15').to_a - achieved

    {
      achieved: achieved,
      pending: pending
    }.to_json
  end

  get '/user/:user_id/rank', provides: :json do
    user = Repos::Users.find(id: params[:user_id]).first
    pincode = user.pincode rescue 'TUCODIGO'
    sponsor = Repos::Sponsor.all.first
    url = sponsor.url_template % {pincode: pincode} rescue ''

    {
      uid: params[:user_id],
      prize: {
        pincode: pincode,
        url: url,
        sponsors: request.url.gsub(request.path, "/logos/logo-monster-color.png"),
        copyright: ''
      }
    }.to_json
  end

  get '/challenge/:user_id/:beacon_minor', provides: :json do |player, beacon|

    halt({
      status: :ko,
      reason: :invalid_beacon_minor_length
    }.to_json) if beacon.length != 3

    lock_number = beacon[0].to_i
    centre = beacon[1..2]

    halt({
      status: :ko,
      reason: :invalid_beacon_minor_number
    }.to_json) if (lock_number < 0 || lock_number > 3)

    this_lock = Repos::Locks.find(id: lock_number).first

    halt({
      status: :ko,
      reason: :unexisting_lock
    }.to_json) unless this_lock

    image_hash = Repos::Sponsor.find(id: :the_sponsor).first.image_hash

    captures = Repos::Captures.find(user: player, tile: this_lock.tile, image: image_hash).length

    return this_lock.to_h.merge({
      asset: url(this_lock.asset),
      unlock_url: url("/unlock/#{player}/#{beacon}")
    }).to_json if captures == 0

    this_bounty = Repos::Bounties.find(id: lock_number).first
    this_bounty.to_h.merge({
      asset: url(this_bounty.asset),
      unlock_url: url("/unlock/#{player}/#{beacon}")
    }).to_json
  end

  get '/unlock/:user_id/:beacon_minor', provides: :json do |player, beacon|
    halt({
      status: :ko,
      reason: :invalid_beacon_minor_length
    }.to_json) if beacon.length != 3

    lock_number = beacon[0].to_i
    centre = beacon[1..2]

    halt({
      status: :ko,
      reason: :invalid_beacon_minor_number
    }.to_json) if (lock_number < 0 || lock_number > 3)

    lock = Repos::Locks.find(id: lock_number).first

    halt({
      status: :ko,
      reason: :unexisting_lock
    }.to_json) unless lock

    image_hash = Repos::Sponsor.find(id: :the_sponsor).first.image_hash

    captures = Repos::Captures.find(user: player, tile: lock.tile, image: image_hash).length

    halt({
      status: :ok
    }.to_json) if captures > 0

    MetricsLogger.unlock player, lock_number, centre
    Repos::Captures.save(image: image_hash, user: player, tile: lock.tile)

    {
      status: :ok
    }.to_json
  end

  get '/admin' do
    erb :admin
  end

  get '/puzzle/index.html' do
    player_id = params[:player_id]
    cache_booster = Time.now.to_i

    redirect to("http://#{request.host_with_port}/puzzle/index.html?t=#{cache_booster}&player_id=#{player_id}"), 301 if request.secure?

    pass
  end

  get '/puzzle/?' do
    player_id = params[:player_id]
    cache_booster = Time.now.to_i

    redirect to("/puzzle/index.html?t=#{cache_booster}&player_id=#{player_id}"), 307
  end
end
