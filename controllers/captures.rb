Captures = Monster::CRUD.for Repos::Captures, '/captures' do

  post settings.prefix + '/?', provides: :json do
    captures = settings.repo.find(user: params[:user], tile: params[:tile], image: params[:image]).length

    halt ok if captures > 0

    settings.repo.save params

    ok
  end
end
