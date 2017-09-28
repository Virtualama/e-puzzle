describe App do
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

  describe 'play' do
    it 'gives world for player, centre and monster' do
      centre = 'WX'
      monster = 'YZ'

      beacon = monster + centre
      player = '654321'

      get "/play/#{player}/#{beacon}"
      expect(parsed_response[:status]).to eq('ok')

      expect(parsed_response[:world]).to include(player)
      expect(parsed_response[:world]).to include(centre)
      expect(parsed_response[:world]).to include(monster)

      query = url_query_to_hash parsed_response[:world]

      expect(query[:centre]).to eq(centre)
      expect(query[:monster]).to eq(monster)
      expect(query[:player]).to eq(player)
    end

    it 'retuns error if invalid beacon given' do
      player = 'any_player_id'
      beacon = 'an_invalid_format_beacon'

      get "/play/#{player}/#{beacon}"

      expect(parsed_response[:status]).to eq('ko')
      expect(parsed_response[:reason]).to eq('invalid_beacon_minor')
    end
  end
end

