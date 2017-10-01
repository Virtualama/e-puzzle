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
    captured_tile = params[:tile].to_i

    captures = settings.repo.find(user: params[:user], tile: captured_tile, image: params[:image]).length

    halt ok if captures > 0

    locked_tile = LOCKS.map{ |lock| lock[:tile] }.include? captured_tile
    # locked_tile = Repos::Locks.find(image: params[:image], tile: captured_tile).first

    halt ko(reason: :locked) if locked_tile

    settings.repo.save params.merge(
      tile: captured_tile
    )

    total_captures_for_image = settings.repo.find(user: params[:user], image: params[:image]).length

    halt ok if total_captures_for_image < 15

    pincode_to_be_assigned = Repos::Pincodes.find(assigned: false).first
    Repos::Pincodes.update pincode_to_be_assigned.id, assigned: true

    code = pincode_to_be_assigned.code

    user = Repos::Users.find(id: params[:user]).first

    if user.nil?
      Repos::Users.save id: params[:user], pincode: code
    else
      Repos::Users.update user.id, pincode: code
    end

    ok
  end
end
