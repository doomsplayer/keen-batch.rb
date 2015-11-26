module KeenNative
  
  class KeenNativeResult
    def initialize(r)
      raise "[keen_native] get data error" if r.null?
      @result = r
      @abandoned = false
    end
    def self.from_redis(url, key, type)
      raise TypeError.new "data type must be ResultType" if !(type.class < ResultType)
      key = key.to_s
      url = url.to_s
      result = KeenIoBooster.from_redis(url, key, type.id)
      raise "[keen_native] get data from redis error" if result.null?
      KeenNativeResult.new(result)
    end
    def accumulate(type)
      if @abandoned
        raise "object abandoned"
      end
      
      raise TypeError.new "data type must be ResultType" if !(type.class < ResultType)
      result = KeenIoBooster.accumulate(@result, type.id)
      @abandoned = true
      raise "[keen_native] accumulate error" if result.null?
      
      KeenNativeResult.new(result)
    end
    def select(key, value, type)
      if @abandoned
        raise "object abandoned"
      end
      
      key = key.to_s
      value = value.to_s
      raise TypeError.new "data type must be ResultType" if !(type.class < ResultType)
      result = KeenIoBooster.select(@result, key, value, type.id)
      @abandoned = true
      raise "[keen_native] select error" if result.null?
      
      KeenNativeResult.new(result)
    end
    def to_redis(key, expire)
      if @abandoned
        raise "object abandoned"
      end
      
      key = key.to_s
      raise TypeError.new "expire must be Fixnum" if expire.class != Fixnum
      raise "[keen_native] set to redis fail" if !KeenIoBooster.to_redis(@result, key, expire)
    end
    def data
      if @abandoned
        raise "object abandoned"
      end
      
      d = KeenIoBooster.result_data(@result)
      @abandoned = true
      raise "[keen_native] get data from result error" if d.null?
      nd = String.new(d.read_string)
      KeenIoBooster.dealloc_str(d)
      nd
    end
  end
  
end
