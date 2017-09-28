xdescribe 'API - Sponsor' do
  before(:each){
    Repos::Sponsor.save(
      url_template: 'http://xxx.yyy.zzz?code=%{pincode}',
      images: []
    )
  }

  it 'url template can be changed' do
    put '/api/sponsor/the_sponsor', url_template: 'xxx'
    expect(parsed_response[:status]).to eq('ok')

    expect(Repos::Sponsor.find(id: :the_sponsor).first.url_template).to eq('xxx')
  end

  it 'images array can be changed' do
    put '/api/sponsor/the_sponsor', images: [:one, :two]
    expect(parsed_response[:status]).to eq('ok')

    expect(Repos::Sponsor.find(id: :the_sponsor).first.images).to eq(['one', 'two'])
  end

  it 'returns selected images' do
    put '/api/sponsor/the_sponsor', images: [:one, :two]
    expect(parsed_response[:status]).to eq('ok')

    get '/api/sponsor/the_sponsor/selections'
    expect(parsed_response[:list]).to eq('onetwo')
  end

  xit 'composes image according to selection' do
    get '/api/sponsor/image'
  end

  describe 'Copyright' do
    it 'returns empty string for trademark without notice' do
      expect(ImagesService.copyright_for 'F').to eq('')
    end

    it 'returns sponsor for a trademark' do
      nestea_copyright_text = 'Nestea es una marca registrada de Société des Produits Nestlé S.A licenciada a Beverage Partners Worldwide (Europa) A.G.'
      expect(ImagesService.copyright_for 'D').to eq(nestea_copyright_text)
    end

    it 'deduplicates copyright texts' do
      both_trademarks_text = 'Coca-Cola y Fanta son marcas registradas de The Coca-Cola Company.'

      expect(ImagesService.copyright_for 'AB').to eq(both_trademarks_text)
    end

    it 'trademarks are separated with commas, last with "y"' do
      both_trademarks_text = 'Coca-Cola, Fanta y Aquarius son marcas registradas de The Coca-Cola Company.'

      expect(ImagesService.copyright_for 'ABC').to eq(both_trademarks_text)
    end

    it 'no copyright trademarks can be mixed with copyright ones' do
      both_trademarks_text = 'Coca-Cola y Fanta son marcas registradas de The Coca-Cola Company.'

      expect(ImagesService.copyright_for 'ABF').to eq(both_trademarks_text)
    end

    it 'different copyrights are separated with a space' do
      both_trademarks_text = 'Coca-Cola es marca registrada de The Coca-Cola Company. Royal Bliss y su logotipo son marcas registradas de The Coca-Cola Company.'

      expect(ImagesService.copyright_for 'AJ').to eq(both_trademarks_text)
    end
  end
end
