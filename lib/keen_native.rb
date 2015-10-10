require "keen_native/version"
require 'eventmachine'
require 'fiddle'
require 'time'
require 'keen_native_bin'

class KeenNative
  libkeen = Fiddle.dlopen(File.dirname(__FILE__) + '/libkeen.so')
  @@new_options = Fiddle::Function.new(
    libkeen['new_options'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  @@get_data = Fiddle::Function.new(
    libkeen['get_data'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  @@set_redis = Fiddle::Function.new(
    libkeen['set_redis'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOID
  )
  @@set_aggregate = Fiddle::Function.new(
    libkeen['set_aggregate'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOID
  )
  @@set_debug = Fiddle::Function.new(
    libkeen['set_debug'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOID
  )
  @@dealloc_str = Fiddle::Function.new(
    libkeen['dealloc_str'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOID
  )

  def initialize(url, pid, from_time)
    if url.class != String
      raise "connection must be string"
    end
    if from_time.class != DateTime
      raise "from_time must be datetime"
    end

    @options = @@new_options.call(url, pid.to_i, from_time.iso8601)
  end

  def get_data
    if @options.nil?
      raise "get_data can only be called once"
    end
    str = @@get_data.call(@options)
    @options = nil

    result = str.to_s
    self.class.dtor_str(str)
    result
  end

  def get_data_async(&block)
    if @options.nil?
      raise "get_data can only be called once"
    end

    EM.schedule do
      result = get_data
      block.call(result)
    end
  end

  def set_redis(redis_conn)
    if redis_conn.class != String
      raise "connection must be string"
    end
    @@set_redis.call(@options, redis_conn)
    self
  end

  def set_aggregate
    @@set_aggregate.call(@options)
  end

  def set_debug
    @@set_debug.call(@options, 1)
    self
  end
  private
  def self.dtor_str(str)
    @@dealloc_str.call(str)
  end
end
