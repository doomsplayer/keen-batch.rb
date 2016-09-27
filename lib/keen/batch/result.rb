module Keen::Batch
  class Result
    def initialize(r)
      FFI.check(r) { |t| t.null? }
      @result = r
      @abandoned = false
    end

    def self.from_redis(url, key, type)
      raise TypeError.new "data type must be ResultType" if !(type < Types::Result::ResultType)
      result = FFI.from_redis(url.to_s, key.to_s, type.id)
      FFI.check(result) { |t| t.null? }
      Result.new(result)
    end

    def accumulate(type)
      raise "object abandoned" if @abandoned
      raise TypeError.new "data type must be ResultType" if !(type < Types::Result::ResultType)

      result = FFI.accumulate(@result, type.id)
      @abandoned = true
      FFI.check(result) { |t| t.null? }
      @result = result
      @abandoned = false
      self
    end

    def select(key, value, type)
      raise "object abandoned" if @abandoned

      raise TypeError.new "data type must be ResultType" if !(type < Types::Result::ResultType)
      result = FFI.select(@result, key.to_s, value.to_s, type.id)
      @abandoned = true
      FFI.check(result) { |t| t.null? }
      @result = result
      @abandoned = false
      self
    end

    def range(from, to)
      raise "object abandoned" if @abandoned

      raise TypeError.new "from and to must be DateTime" if !(from.class == DateTime || to.class == DateTime)
      result = FFI.range(@result, from.rfc3339, to.rfc3339)
      @abandoned = true
      FFI.check(result) { |t| t.null? }

      @result = result
      @abandoned = false
      self
    end

    def to_redis(key, expire)
      raise "object abandoned" if @abandoned
      raise TypeError.new "expire must be Fixnum" if expire.class != Fixnum

      FFI.check(FFI.to_redis(@result, key.to_s, expire)) { |t| t.zero? }
    end

    def to_s
      raise "object abandoned" if @abandoned

      d = FFI.to_string(@result)
      @abandoned = true
      @result = nil
      FFI.check(d) { |t| t.null? }
      nd = String.new(d.read_string)
      FFI.free_string(d)
      nd
    end

    def free
      FFI.free_result(@result)
      @result = nil
      @abandoned = true
    end
  end
end


