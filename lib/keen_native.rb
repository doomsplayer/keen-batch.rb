require "keen_native/version"
require 'eventmachine'
require 'fiddle'
require 'time'

module KeenNative
  libkeen = Fiddle.dlopen(File.dirname(__FILE__) + '/libkeen_native.so')
  @@cache_with_field_range = Fiddle::Function.new(
    libkeen['cache_with_field_range_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def self.cache_with_field_range(pfrom, pto, field, from, to, unique=false)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@cache_with_field_range.call(pfrom.to_i, pto.to_i, field, from.iso8601, to.iso8601, unique ? 1 : 0)
    str = result.to_s
    self.dtor_str(result)
    str
  end

  @@get_with_field_range = Fiddle::Function.new(
    libkeen['get_with_field_range_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def self.get_with_field_range(pid, pfrom, pto, field, from, to, unique=false)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@get_with_field_range.call(pid.to_i, pfrom.to_i, pto.to_i, field, from.iso8601, to.iso8601, unique ? 1 : 0)
    str = result.to_s
    self.dtor_str(result)
    str
  end

  @@cache_page_view_range = Fiddle::Function.new(
    libkeen['cache_page_view_range_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def self.cache_page_view_range(pfrom, pto, from, to, unique=false, interval="")
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@cache_page_view_range.call(pfrom.to_i, pto.to_i, from.iso8601, to.iso8601, unique ? 1 : 0, interval)
    str = result.to_s
    self.dtor_str(result)
    str
  end

  @@get_page_view_range = Fiddle::Function.new(
    libkeen['get_page_view_range_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def self.get_page_view_range(pid, pfrom, pto, from, to, unique=false, interval="")
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@get_page_view_range.call(pid.to_i, pfrom.to_i, pto.to_i, from.iso8601, to.iso8601, unique ? 1 : 0, interval)
    str = result.to_s
    self.dtor_str(result)
    str
  end

  @@dealloc_str = Fiddle::Function.new(
    libkeen['dealloc_str'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOID
  )

  private
  def self.dtor_str(str)
    @@dealloc_str.call(str)
  end
end
