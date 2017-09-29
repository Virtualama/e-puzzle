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
      reason: :invalid_beacon_minor
    }.to_json) if beacon.length != 3

    lock = beacon[0].to_i - 1
    centre = beacon[1..2]

    halt({
      status: :ko,
      reason: :invalid_beacon_minor
    }.to_json) if (lock < 0 || lock > 3)

    this_lock = Repos::Captures::LOCKS[lock]
    this_lock.merge({
      asset: url(this_lock[:asset]),
      unlock_url: url("/unlock/#{player}/#{beacon}")
    }) .to_json
  end

  get '/unlock/:user_id/:beacon_minor', provides: :json do |player, beacon|
    halt({
      status: :ko,
      reason: :invalid_beacon_minor
    }.to_json) if beacon.length != 3

    lock = beacon[0].to_i - 1
    centre = beacon[1..2]

    halt({
      status: :ko,
      reason: :invalid_beacon_minor
    }.to_json) if (lock < 0 || lock > 3)


    Repos::Captures.save image: 'otter', user: player, tile: Repos::Captures::LOCKS[lock][:tile]

    {
      status: :ok
    }.to_json
  end

  get '/admin' do
    erb :admin
  end

  get '/puzzle/' do
    send_file File.join(settings.public_folder, 'puzzle/index.html')
  end
end
