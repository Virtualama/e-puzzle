module Mongo
  class Client

    def initialize *_
      @coll = []
    end

    def [] *_
      self
    end

    def insert *doc
      @coll.push(*doc)
      ap @coll
    end

    def find **selector
      @coll.select { |x|
        selector.keys.all? { |k|
          x.keys.include?(k) && x[k] == selector[k]
        }
      }
    end
  end
end
