Captures = Monster::CRUD.for Repos::Captures, '/captures' do

  LOCKS = [{
    tile: 2,
    asset: '/images/monster.jpg',
    time: 10,
    type: :image
  },{
    tile: 4,
    asset: 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    time: 10,
    type: :video
  },{
    tile: 6,
    asset: 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    time: 10,
    type: :video
  },{
    tile: 8,
    asset: '/images/monster.jpg',
    time: 10,
    type: :image
  }]

  post settings.prefix + '/?', provides: :json do
    captures = settings.repo.find(user: params[:user], tile: params[:tile], image: params[:image]).length

    halt ok if captures > 0

    halt ko(reason: :locked) if LOCKS.map{ |lock| lock[:tile] }.include? params[:tile].to_i

    settings.repo.save params.merge(
      tile: params[:tile].to_i
    )

    ok
  end
end
