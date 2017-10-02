Sponsors = Monster::CRUD.for Repos::Sponsor, '/sponsor' do

  class ImageHasher
    def self.hash url
      require 'digest'
      Digest::MD5.hexdigest(url)
    end
  end

  post settings.prefix + '/?', provides: :json do
    ko(reason: :sponsor_was_created)
  end

  put settings.prefix + '/the_sponsor', provides: :json do
    sponsor = Repos::Sponsor.find(id: :the_sponsor).first
    Repos::Sponsor.save url_template: '', image_url: '', image_hash: '' unless sponsor

    update = params.reject{ |k,_| k == :id}
    halt ok if update.empty?

    update.merge!({
      image_hash: ImageHasher.hash(params[:image_url])
    }) if params[:image_url]

    settings.repo.update :the_sponsor, update

    ok
  end

  get settings.prefix + '/the_sponsor/selections', provides: :json do
    sponsor = Repos::Sponsor.all.first
    url_template = sponsor.url_template rescue ''
    image_url = sponsor.image_url rescue ''

    {
      url_template: url_template,
      image_url: image_url
    }.to_json
  end
end
