describe 'metrics gathering' do
  let(:fake_metrics){
    double('fake_metrics')
  }

  before(:each){ |test|
    Repos::Sponsor.save(
      url_template: 'http://xxx.yyy.zzz?code=%{pincode}',
      image_url: 'some_image_url',
      image_hash: 'some_image_url_hash',
      size: {
        horizontal: 3,
        vertical: 3
    })

    Repos::Locks.save tile: '1', time: '10', asset: 'aaa', type: 'image', image: 'some_image_url_hash', id: 0
    Repos::Locks.save tile: '2', time: '10', asset: 'aaa', type: 'image', image: 'some_image_url_hash', id: 1
    Repos::Locks.save tile: '3', time: '10', asset: 'aaa', type: 'image', image: 'some_image_url_hash', id: 2
    Repos::Locks.save tile: '4', time: '10', asset: 'aaa', type: 'image', image: 'some_image_url_hash', id: 3
    Repos::Pincodes.save code: '1234'

    stub_const('::MetricsLogger', fake_metrics)
    allow(fake_metrics).to receive(:unlock)
    allow(fake_metrics).to receive(:full_unlock)
    allow(fake_metrics).to receive(:complete)
  }

  it 'works when last capture is from a click' do
    centre = 'WX'
    lock = '%{lock}'

    beacon = lock + centre
    player = '654321'

    (1..4).each { |lock|
      get "/unlock/#{player}/#{beacon}" % {lock: lock}
      expect(fake_metrics).to have_received(:unlock).exactly(lock).times
    }
    get "/api/captures/by_user/#{player}"
    expect(parsed_response[:list].length).to eq(4)

    (5..8).each { |tile|
      post '/api/captures', tile: tile, user: player, image: :some_image_url_hash
    }
    get "/api/captures/by_user/#{player}"
    expect(parsed_response[:list].length).to eq(8)
    expect(fake_metrics).to have_received(:full_unlock)

    post '/api/captures', tile: 0, user: player, image: :some_image_url_hash
    get "/api/captures/by_user/#{player}"

    expect(parsed_response[:list].length).to eq(9)
    expect(fake_metrics).to have_received(:complete)
  end

  it 'works when last capture is from a beacon' do
    centre = 'WX'
    lock = '%{lock}'

    beacon = lock + centre
    player = '654321'

    (5..8).each { |tile|
      post '/api/captures', tile: tile, user: player, image: :some_image_url_hash
    }
    get "/api/captures/by_user/#{player}"
    expect(parsed_response[:list].length).to eq(4)

    (1..4).to_a.each { |lock|
      5.times.each { |time|
        get "/unlock/#{player}/#{beacon}" % {lock: lock}
        expect(fake_metrics).to have_received(:unlock).exactly(lock).times
      }
    }
    get "/api/captures/by_user/#{player}"
    expect(parsed_response[:list].length).to eq(8)
    expect(fake_metrics).to have_received(:full_unlock)

    post '/api/captures', tile: 0, user: player, image: :some_image_url_hash
    get "/api/captures/by_user/#{player}"

    expect(parsed_response[:list].length).to eq(9)
    expect(fake_metrics).to have_received(:complete)
  end
end
