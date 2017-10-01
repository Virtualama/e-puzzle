Pincodes = Monster::CRUD.for Repos::Pincodes, '/pincodes' do

  post settings.prefix + '/upload/?' do
    begin
      halt redirect to(request.referer) if (params[:file].nil? || params[:file].empty?)
      codes_to_add = params[:file][:tempfile].readlines.map(&:chomp)
      codes_to_add.each do |code|
        Repos::Pincodes.save code: code
      end
      redirect to(request.referer)
    rescue StandardError
      'Error al cargar los pincodes del fichero'
    end
  end

  get settings.prefix + '/count/?', provides: :json do
    {
      count: Repos::Pincodes.collection.count(assigned: false)
    }.to_json
  end

end
