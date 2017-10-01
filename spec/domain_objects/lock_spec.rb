describe 'Lock' do

  it 'needs an image, tile, type, time and asset to be created' do
    expect{
      Lock.new tile: '3', time: '10', asset: 'aaa', type: 'image'
    }.to raise_error(StandardError, /:image is missing/)

    expect{
      Lock.new image: 'xxx', time: '10', asset: 'aaa', type: 'image'
    }.to raise_error(StandardError, /:tile is missing/)

    expect{
      Lock.new image: 'xxx', asset: 'aaa', tile: '3', type: 'image'
    }.to raise_error(StandardError, /:time is missing/)

    expect{
      Lock.new image: 'xxx', tile: '3', time: '10', type: 'image'
    }.to raise_error(StandardError, /:asset is missing/)

    expect{
      Lock.new image: 'xxx', tile: '3', time: '10', asset: 'aaa'
    }.to raise_error(StandardError, /:type is missing/)

    expect{
      Lock.new image: 'xxx', tile: '3', time: '10', asset: 'aaa', type: 'video'
    }.not_to raise_error
  end
end
