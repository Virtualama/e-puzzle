require 'dry-struct'
require 'securerandom'
require 'dry-types'

module Types
  include Dry::Types.module

  Rank = Types::String.enum(*%w(premiere active elite))
  Assigned = Types::Bool.default(false)
  Now = Types::Form::Time.default { ::Time.now }
  Id = Types::String.constrained(
    format: /^\h{8}-\h{4}-[1-5]\h{3}-[89ab]\h{3}-\h{12}$/
  ).default { SecureRandom.uuid }
end

class DomainObject < Dry::Struct
  def self.new hash, &block
    symbolized_hash = Hash[hash.map { |k, v|
      # next unless attribute_names.include?(k.to_sym)
      next if k == '_id'
      [k.to_sym, v]
    }.compact]

    super symbolized_hash, &block
  end

  def to_json **opts
    to_h.to_json **opts
  end
end

class User < DomainObject
  constructor_type :strict_with_defaults

  attribute :id, Types::String
  attribute :pincode, Types::String.optional.default(nil)
end

class Capture < DomainObject
  constructor_type :strict_with_defaults

  attribute :user, Types::String
  attribute :tile, Types::String
  attribute :image, Types::String
  attribute :created_at, Types::Now
end

class Pincode < DomainObject
  constructor_type :strict_with_defaults

  attribute :id, Types::Id
  attribute :code, Types::String
  attribute :assigned, Types::Assigned
end

class Sponsor < DomainObject
  constructor_type :strict_with_defaults

  attribute :id, Types::String.default('the_sponsor')
  attribute :url_template, Types::String
  attribute :image_url, Types::String
  attribute :image_hash, Types::String
end