describe 'Pincode' do

  let(:uuid_regex){
    /^\h{8}-\h{4}-[1-5]\h{3}-[89ab]\h{3}-\h{12}$/
  }

  it 'is not assigned at creation' do
    created_pincode = Pincode.new code: 'aabbcc'

    expect(created_pincode.assigned).to eq(false)
  end

  it 'gets an id if not given' do
    created_pincode = Pincode.new code: 'aabbcc'

    expect(created_pincode.id).to match(uuid_regex)
  end

  it 'id must be a valid uuid' do
    expect {
      Pincode.new code: 'aabbcc', id: 'xxx'
    }.to raise_error(StandardError, /:id violates constraints/)
  end
end