describe App do
  before(:each){ |test|
    Repos::Sponsor.save(
      url_template: 'http://xxx.yyy.zzz?code=%{pincode}',
      image_url: 'some_image_url',
      image_hash: 'some_image_url_hash',
      size: {
        horizontal: 3,
        vertical: 3
    })
  }

  it 'works' do
    get '/'

    expect(last_response.status).to eq 200
  end

  describe 'user' do
    it 'returns current uid when logged' do
      device_id = '5fskjh5654akjhgasd'

      post '/user/login', user_id: device_id

      expect(parsed_response[:user_id]).to eq(device_id)
    end

    it 'returns a list of achieved monsters' do
      player = '654321'

      get "/user/#{player}/achievements"

      expect(parsed_response[:achieved]).to be_a(Array)
      expect(parsed_response[:achieved].length).to eq(0)

      expect(parsed_response[:pending]).to be_a(Array)
      expect(parsed_response[:pending].length).to eq(15)
    end
  end

  describe 'challenge' do
    it 'retuns error if invalid beacon given' do
      player = 'any_player_id'
      beacon = 'an_invalid_format_beacon'

      get "/challenge/#{player}/#{beacon}"

      expect(parsed_response[:status]).to eq('ko')
      expect(parsed_response[:reason]).to eq('invalid_beacon_minor_length')
    end

    it 'retuns error if beacon is not between 1xx & 4xx' do
      player = 'any_player_id'
      beacon = '5xx'

      get "/challenge/#{player}/#{beacon}"

      expect(parsed_response[:status]).to eq('ko')
      expect(parsed_response[:reason]).to eq('invalid_beacon_minor_number')
    end

    it 'retuns error if there is not a lock for that beacon' do
      player = 'any_player_id'
      beacon = '3xx'

      get "/challenge/#{player}/#{beacon}"

      expect(parsed_response[:status]).to eq('ko')
      expect(parsed_response[:reason]).to eq('unexisting_lock')
    end

    it 'gives an asset & unlock_url for a lock' do

      Repos::Locks.save tile: '3', time: '10', asset: 'aaa', type: 'image', image: 'xxx'

      centre = 'WX'
      lock = '1'

      beacon = lock + centre
      player = '654321'

      get "/challenge/#{player}/#{beacon}"

      expect(parsed_response.keys).to include('asset', 'unlock_url')
    end

  end
end

