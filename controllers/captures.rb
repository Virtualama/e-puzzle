Captures = Monster::CRUD.for Repos::Captures, '/captures' do

  post settings.prefix + '/?', provides: :json do
    captured_tile = params[:tile].to_i

    captures = settings.repo.find(user: params[:user], tile: captured_tile, image: params[:image]).length

    halt ok if captures > 0

    locked_tile = Repos::Locks.find(tile: captured_tile).first

    halt ko(reason: :locked) if locked_tile

    settings.repo.save params.merge(
      tile: captured_tile
    )

    total_captures_for_image = settings.repo.find(user: params[:user], image: params[:image]).length

    size = Repos::Sponsor.find(id: :the_sponsor).first.size
    total_tiles = size.horizontal * size.vertical

    MetricsLogger.full_unlock params[:user] if total_captures_for_image == total_tiles - 1

    halt ok if total_captures_for_image < total_tiles

    MetricsLogger.complete params[:user], params[:image]

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

  get settings.prefix + '/export' do
    attachment 'metrics.csv'

    require 'csv'
    csv_str = CSV.generate force_quotes: true, col_sep: ';' do |csv|
      csv << [:user, :tile, :centre, :image, :timestamp]
      settings.repo.all.each do |capture|
        csv << [capture.user, capture.tile, capture.centre, capture.image, capture.created_at]
      end
    end
  end

end
