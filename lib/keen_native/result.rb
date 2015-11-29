module KeenNative
  class KeenNativeResult
    def initialize(r)
      raise "[keen_native] get data error" if r.null?
      @result = r
      @abandoned = false
    end
    def self.from_redis(url, key, type)
      raise TypeError.new "data type must be ResultType" if !(type < Result::ResultType)
      key = key.to_s
      url = url.to_s
      result = KeenIoBooster.from_redis(url, key, type.id)
      raise "[keen_native] get data from redis error" if result.null?
      KeenNativeResult.new(result)
    end
    def accumulate(type)
      raise "object abandoned" if @abandoned

      raise TypeError.new "data type must be ResultType" if !(type < Result::ResultType)
      result = KeenIoBooster.accumulate(@result, type.id)
      @abandoned = true
      raise "[keen_native] accumulate error" if result.null?

      KeenNativeResult.new(result)
    end
    def select(key, value, type)
      raise "object abandoned" if @abandoned

      key = key.to_s
      value = value.to_s
      raise TypeError.new "data type must be ResultType" if !(type < Result::ResultType)
      result = KeenIoBooster.select(@result, key, value, type.id)
      @abandoned = true
      raise "[keen_native] select error" if result.null?

      KeenNativeResult.new(result)
    end
    def range(from, to)
      raise "object abandoned" if @abandoned
      raise TypeError.new "from and to must be DateTime" if !(from.class == DateTime || to.class == DateTime)
      result = KeenIoBooster.range(@result, from.rfc3339, to.rfc3339)
      @abandoned = true
      raise "[keen_native] range error" if result.null?
      KeenNativeResult.new(result)
    end
    def to_redis(key, expire)
      raise "object abandoned" if @abandoned

      key = key.to_s
      raise TypeError.new "expire must be Fixnum" if expire.class != Fixnum
      raise "[keen_native] set to redis fail" if KeenIoBooster.to_redis(@result, key, expire).zero?
    end
    def data
      raise "object abandoned" if @abandoned

      d = KeenIoBooster.result_data(@result)
      @abandoned = true
      raise "[keen_native] get data from result error" if d.null?
      nd = String.new(d.read_string)
      KeenIoBooster.dealloc_str(d)
      nd
    end
    def release
      KeenIoBooster.delete_result(@result)
      @abandoned = true
    end
  end
end
