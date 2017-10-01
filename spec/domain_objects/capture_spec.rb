describe 'Capture' do

  it 'needs user, tile and image fields to be created' do
    expect{
      Capture.new user: 'xxx', tile: '5'
    }.to raise_error(StandardError, /:image is missing/)

    expect{
      Capture.new tile: '5', image: 'zzz'
    }.to raise_error(StandardError, /:user is missing/)

    expect{
      Capture.new user: 'any_user', tile: '3', image: 'any_image'
    }.not_to raise_error
  end

  it 'gets a creation date assigned if not given' do
    created_capture = Capture.new user: 'any_user', tile: '3', image: 'any_image', created_at: '5:00 pm'

    expect(created_capture.created_at).to be_a(Time)

    created_capture = Capture.new user: 'any_user', tile: '3', image: 'any_image'

    expect(created_capture.created_at).to be_a(Time)
  end
end
