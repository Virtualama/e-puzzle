require 'mongo'
require './repos/meta_repo'
require './domain_objects'

Mongo::Logger.level = Logger::FATAL
mongo_url = ENV['MONGODB_URI'] || "mongodb://localhost/e-puzzle_#{ENV['RACK_ENV']}"
connection = Mongo::Client.new(mongo_url)

Repos = Module.new

Repos::Users = MetaRepo.for User, connection[:users]
Repos::Captures = MetaRepo.for Capture, connection[:captures]
Repos::Pincodes = MetaRepo.for Pincode, connection[:pincodes]
Repos::Sponsor = MetaRepo.for Sponsor, connection[:sponsor]
Repos::Locks = MetaRepo.for Lock, connection[:locks]
