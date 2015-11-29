module KeenNative
  class KeenNativeClient
    def initialize(key, project)
      key = key.to_s
      project = project.to_s
      raise TypeError.new "key must be string" if key.class != String
      raise TypeError.new "project must be string" if project.class != String

      @native_client = KeenIoBooster.new(key, project)
      raise "[keen_native] get keen native client error" if @native_client.null?
    end
    def set_redis!(url)
      url = url.to_s
      raise TypeError.new "url must be string" if url.class != String
      raise "[keen_native] set redis error" if KeenIoBooster.set_redis(@native_client, url).zero?
      self
    end
    def set_timeout!(tick)
      raise TypeError.new "timeout must be a num" if tick.class != Fixnum
      raise "[keen_native] set_timeout error" if KeenIoBooster.set_timeout(@native_client, tick).zero?
      self
    end

    def query(metrics, collection, start, to)
      collection = collection.to_s
      raise TypeError, "start must be DateTime" if start.class != DateTime
      raise TypeError, "to must be DateTime" if to.class != DateTime
      raise TypeError.new "metrics must be MetricsType" if !(metrics.class < Metrics::MetricsType)
      raise TypeError.new "collection must be string convertable" if collection.class != String
      query = KeenIoBooster.query(@native_client, metrics.id, metrics.target, collection, start.rfc3339, to.rfc3339)
      raise "[keen_native] new query error" if query.null?

      KeenNativeQuery.new(query)
    end
  end
end
