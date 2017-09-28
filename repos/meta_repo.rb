module MetaRepo
  module Base

    def self.extended base
      base.class_eval do
        def initialize *_
          raise StandardError, 'Repos cannot be instantiated, they\'re just classes'
        end
      end
    end

    def save object
      object_to_save = mapped_class.new object
      collection.insert_one object_to_save.to_h
    end

    def find query
      collection.find(query).map { |doc|
        mapped_class.new doc
      }
    end

    def delete id
      collection.delete_one(id: id)
    end

    def update id, changes
      collection.update_one({id: id}, {'$set' => changes})
    end

    def all
      self.find({})
    end

    def clear
      collection.drop
    end

    def meth name, &block
      self.define_singleton_method name, &block
    end
  end

  def self.for mapped_class, collection, &block
    Class.new do |created_class|
      created_class.extend Base

      created_class.define_singleton_method :collection do
        collection
      end

      created_class.define_singleton_method :mapped_class do
        mapped_class
      end

      # yield created_class if block_given?
      created_class.class_eval(&block) if block_given?
    end
  end
end
