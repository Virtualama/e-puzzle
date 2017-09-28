Sponsors = Monster::CRUD.for Repos::Sponsor, '/sponsor' do

  put settings.prefix + '/the_sponsor', provides: :json do
    sponsor = Repos::Sponsor.find(id: :the_sponsor).first
    Repos::Sponsor.save url_template: '' unless sponsor

    update = params.reject{ |k,_| k == :id}
    halt ok if update.empty?

    settings.repo.update :the_sponsor, update

    ok
  end

  get settings.prefix + '/the_sponsor/selections', provides: :json do
    sponsor = Repos::Sponsor.all.first
    url = sponsor.url_template rescue ''

    {
      url: url
    }.to_json
  end
end
