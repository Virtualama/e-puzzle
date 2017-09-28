describe 'fixtures' do

  it 'prepares env for test' do
    Repos::Pincodes.save code: 'pincode', rank: 'premiere'

    5.times do |counter|
      post "/api/captures/", monster: "monster_id_#{counter}", user: 'me'
    end
  end

end
