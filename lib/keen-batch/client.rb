module Keen::Batch
  class Client
    def initialize(key, project)
      key = key.to_s
      project = project.to_s
      @client = FFI.check(FFI.new_client(key, project)) do |t|
        t.null?
      end
    end

    def set_redis(url)
      url = url.to_s
      FFI.check(FFI.set_redis(@client, url)) do |t|
        t.zero?
      end
    end

    def set_timeout(tick)
      raise TypeError.new "timeout must be a num" if tick.class != Fixnum
      FFI.check(FFI.set_timeout(@client, tick)) do |t| 
        t.zero?
      end
    end
    def query(metrics, collection, start, to)
      collection = collection.to_s
      raise TypeError, "start must be DateTime" if start.class != DateTime
      raise TypeError, "to must be DateTime" if to.class != DateTime
      raise TypeError.new "metrics must be MetricsType" if !(metrics.class < Metrics::MetricsType)
      raise TypeError.new "collection must be string convertable" if collection.class != String

      query = FFI.query(@client, metrics.id, metrics.target, collection, start.rfc3339, to.rfc3339) do |t|
        t.null?
      end

      Query.new(query)
    end
  end
end
