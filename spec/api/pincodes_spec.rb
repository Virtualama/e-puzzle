describe 'API - Pincodes' do
  it 'can be uploaded from csv file' do
    test_file_path = File.expand_path('../../support/test_pincodes.csv', __FILE__)
    expect(Repos::Pincodes.find(code: 'aabbcc').length).to eq(0)

    post '/api/pincodes/upload/', file: Rack::Test::UploadedFile.new(test_file_path)

    expect(last_response.status).to eq(302)
    expect(Repos::Pincodes.find(code: 'aabbcc').length).to eq(1)
  end
end
