describe 'API - Locks' do
  it 'can be cleared from request' do
    Repos::Locks.save tile: '3', time: '10', asset: 'aaa', type: 'image', image: 'xxx'

    delete '/api/locks/all'

    expect(Repos::Locks.all.count).to eq 0
  end
end
