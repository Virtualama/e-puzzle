require 'mongo'
require './repos/meta_repo'
require './domain_objects'

Mongo::Logger.level = Logger::FATAL
mongo_url = ENV['MONGODB_URI'] || "mongodb://localhost/e-puzzle_#{ENV['RACK_ENV']}"
connection = Mongo::Client.new(mongo_url)

Repos = Module.new

Repos::Users = MetaRepo.for User, connection[:monster_users]
Repos::Captures = MetaRepo.for Capture, connection[:monster_captures]
Repos::Pincodes = MetaRepo.for Pincode, connection[:monster_pincodes]
Repos::Sponsor = MetaRepo.for Sponsor, connection[:monster_sponsor]
Repos::Locks = MetaRepo.for Lock, connection[:monster_locks]
Repos::Bounties = MetaRepo.for Lock, connection[:monster_bounties]
