describe 'API - Captures' do

  let(:user_id){
    'the_user_id'
  }

  let(:current_user_pincode){
    ->(user_id) {
      Repos::Users.find(id: user_id).first.pincode
    }
  }

  let(:assigned_pincode){
    ->(user_id) {
      Repos::Pincodes.find(code: current_user_pincode[user_id]).first
    }
  }

  let(:tile_id){
    5
  }

  it 'adds a captured tile on success' do
    post "/api/captures/", tile: tile_id, user: user_id, image: :the_image_hash
    expect(last_response.status).to eq(200)

    expect(Repos::Captures.all.count).to eq(1)
  end

  it 'returns achievements for given user' do

    post "/api/captures/", tile: tile_id, user: user_id, image: :the_image_hash
    expect(last_response.status).to eq(200)

    post "/api/captures/", tile: tile_id, user: 'other_user_id', image: :the_image_hash
    expect(last_response.status).to eq(200)

    get "/api/captures/by_user/#{user_id}"
    expect(parsed_response[:list]).to be_a(Array)
    expect(parsed_response[:list].length).to eq(1)
    expect(parsed_response[:list]).to include hash_including(tile: tile_id)
  end

  it 'silently ignores same tile multiple captures' do
    Repos::Pincodes.save code: 'pincode'

    post "/api/captures/", tile: tile_id, user: user_id, image: :the_image_hash
    expect(parsed_response[:status]).to eq('ok')

    post "/api/captures/", tile: tile_id, user: user_id, image: :other_image_hash
    expect(parsed_response[:status]).to eq('ok')

    3.times do |counter|
      post "/api/captures/", tile: tile_id, user: user_id, image: :the_image_hash
    end

    expect(Repos::Users.find(id: user_id).length).to eq 0
    expect(Repos::Captures.find(user: user_id).length).to eq 2
    expect(Repos::Captures.find(image: :the_image_hash).length).to eq 1
    expect(Repos::Captures.find(image: :other_image_hash).length).to eq 1
  end

  it 'fails when captured tile is locked' do
    the_locked_tile = 3
    any_unlocked_tile = 5

    Repos::Locks.save(
      image: :the_image_hash,
      tile: the_locked_tile,
      asset: 'xxx',
      type: 'image',
      time: 7
    )

    post "/api/captures/", tile: any_unlocked_tile, user: user_id, image: :the_image_hash
    expect(parsed_response[:status]).to eq('ok')

    post "/api/captures/", tile: the_locked_tile, user: user_id, image: :the_image_hash
    expect(parsed_response[:status]).to eq('ko')
    expect(parsed_response[:reason]).to eq('locked')
  end

  it 'assigns a pincode to a user on 9th' do
    Repos::Pincodes.save code: 'pincode'

    (1..8).each do |idx|
      post "/api/captures/", tile: idx, user: user_id, image: :the_image_hash
    end

    post "/api/captures/", tile: 0, user: user_id, image: :the_image_hash

    expect(assigned_pincode[user_id].code).to eq('pincode')
  end

end
