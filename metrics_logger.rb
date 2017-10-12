require 'keen'

Keen.project_id = "59df7269c9e77c0001156187"
Keen.write_key = "E70A52A32EE3EC606B90C3627E4BB77CD6F36CB1970EB9C089BDDBCD01973BF6F9D5CDCEAA0990683DAE1161DE85EB99A280A7EEBDE1424B0B34399CF76EBC24A859689087A74634D3F77DA85D55B4C120FE7AE56E5A5C96EEC6B4E435BEC691"

class MetricsLogger

  class <<self
    def unlock user, lock, centre
      keen_publish(:unlocks, {
        user: user,
        lock: lock,
        centre: centre
      })
    end

    def full_unlock user
      keen_publish(:full_unlocks, {
        user: user
      })
    end

    def complete user, image
      keen_publish(:completes, {
        user: user,
        image: image
      })
    end

    private
      def keen_publish collection, data
        return if ENV['RACK_ENV'] == 'test'

        if defined?(EventMachine) && EventMachine.reactor_running?
          ap :async
          Keen.send :publish_async, collection, data
        else
          ap :sync
          Keen.send :publish, collection, data
        end
      end
  end
end
