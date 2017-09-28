require 'ap'
require 'rack/cors'
require './controllers/meta_controller'
require './repos'
require './controllers/pincodes'
require './controllers/captures'
require './controllers/sponsors'
require './app'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any
  end
end

Users = Monster::CRUD.for Repos::Users, '/users'

map '/api' do
  use Captures
  use Users
  use Pincodes
  # use Sponsors
  run lambda { |_|
    [200, {}, '_']
  }
end

map '/' do
  run App
end
