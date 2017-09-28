describe 'User' do

  it 'needs an id to be created' do
    expect{
      User.new({})
    }.to raise_error(StandardError, /:id/)

    expect{
      User.new id: 'any_id'
    }.not_to raise_error
  end

  it 'has no pincode assigned at creation' do
    created_pincode = User.new id: '555'

    expect(created_pincode.pincode).to eq(nil)
  end
end
