module KeenNative
  class KeenNativeClient
    def initialize(key, project)
      key = key.to_s
      project = project.to_s
      raise TypeError.new "key must be string" if url.class != String
      raise TypeError.new "project must be string" if url.class != String

      @native_client = KeenIoBooster.new(key, project)
      raise "[keen_native] get keen native client error" if @native_client.null?
    end
    def set_redis(url)
      url = url.to_s
      raise TypeError.new "url must be string" if url.class != String
      raise "[keen_native] set redis error" if !KeenIoBooster.set_redis(@native_client, url)
    end
    def set_timeout(tick)
      raise TypeError.new "timeout must be a num" if url.class != Fixnum
      raise "[keen_native] set_timeout error" if !KeenIoBooster.set_timeout(@native_client, tick)
    end
    
    def query(metrics, collection, start, to)
      collection = collection.to_s
      start = start.to_datetime
      to = to.to_datetime
      raise TypeError.new "metrics must be MetricsType" if !(metrics < MetricsType)
      raise TypeError.new "collection must be string convertable" if collection.class != String
      query = KeenIoBooster.query(@native_client, metrics.id, metrics.target, collection, start.utc.rfc3339, to.utc.rfc3339)
      raise "[keen_native] new query error" if query.null?
      
      KeenNativeQuery.new(query)
    end
  end
end
