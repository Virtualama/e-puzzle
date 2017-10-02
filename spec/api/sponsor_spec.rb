describe 'API - Sponsor' do
  before(:each){ |test|
    Repos::Sponsor.save(
      url_template: 'http://xxx.yyy.zzz?code=%{pincode}',
      image_url: 'some_image_url',
      image_hash: 'some_image_url_hash',
      size: {
        horizontal: 5,
        vertical: 5
      }
    ) unless test.metadata[:no_create]
  }

  it 'cannot be more than one' do
    post '/api/sponsor'

    expect(parsed_response[:status]).to eq('ko')
    expect(parsed_response[:reason]).to eq('sponsor_was_created')
  end

  it 'gets created if not exists at update', :no_create do
    put '/api/sponsor/the_sponsor', url_template: 'xxx'
    expect(Repos::Sponsor.all.length).to eq(1)
  end

  it 'url template can be changed' do
    put '/api/sponsor/the_sponsor', url_template: 'xxx'
    expect(parsed_response[:status]).to eq('ok')

    expect(Repos::Sponsor.find(id: :the_sponsor).first.url_template).to eq('xxx')
  end

  it 'image url can be changed' do
    new_image_url = 'new_image_url'

    put '/api/sponsor/the_sponsor', image_url: new_image_url
    expect(parsed_response[:status]).to eq('ok')

    expect(Repos::Sponsor.find(id: :the_sponsor).first.image_url).to eq(new_image_url)
  end

  it 'image hash depends on image_url' do
    new_image_url = 'new_image_url'

    require 'digest'
    new_image_url_hash = Digest::MD5.hexdigest(new_image_url)

    put '/api/sponsor/the_sponsor', image_url: new_image_url
    expect(parsed_response[:status]).to eq('ok')

    expect(Repos::Sponsor.find(id: :the_sponsor).first.image_url).to eq(new_image_url)
    expect(Repos::Sponsor.find(id: :the_sponsor).first.image_hash).to eq(new_image_url_hash)
  end

  it 'returns selected image image_url & url_template' do
    put '/api/sponsor/the_sponsor', image_url: 'xxx'
    expect(parsed_response[:status]).to eq('ok')

    get '/api/sponsor/the_sponsor/selections'
    expect(parsed_response[:image_url]).to eq('xxx')
  end

  it 'handles tile sizing' do
    put '/api/sponsor/the_sponsor', size: {horizontal: 5, vertical: 5}
    expect(parsed_response[:status]).to eq('ok')
    get '/api/sponsor/the_sponsor/selections'
    expect(parsed_response[:size]).to eq({
      'horizontal' => 5,
      'vertical' => 5
    })
  end
end
