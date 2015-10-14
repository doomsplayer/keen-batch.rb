require "keen_native/version"
require 'eventmachine'
require 'fiddle'
require 'time'

module KeenNative
  libkeen = Fiddle.dlopen(File.dirname(__FILE__) + '/libkeen_native.so')
  @@cache_with_field = Fiddle::Function.new(
    libkeen['cache_with_field_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def cache_with_field(pfrom, pto, field, from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@cache_with_field.call(pfrom.to_i, pto.to_i, field, from, to, unique)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_with_field = Fiddle::Function.new(
    libkeen['get_with_field_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def get_with_field(pid, pfrom, pto, field, from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@get_with_field.call(pid.to_i, pfrom.to_i, pto.to_i, field, from, to, unique)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@cache_page_view = Fiddle::Function.new(
    libkeen['cache_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def cache_unique_page_view(pfrom, pto, from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@cache_unique_page_view.call(pfrom.to_i, pto.to_i, from, to, unique)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_page_view = Fiddle::Function.new(
    libkeen['get_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def get_unique_page_view(pid, pfrom, pto, from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@get_unique_page_view.call(pid.to_i, pfrom.to_i, pto.to_i, from, to, unique)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@cache_total_page_view = Fiddle::Function.new(
    libkeen['cache_total_page_view_c'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def cache_total_page_view(from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@cache_total_page_view.call(from, to, unique)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_total_page_view = Fiddle::Function.new(
    libkeen['get_total_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  def get_total_page_view(pid, from, to, unique)
    if from.class != DateTime && to.class != DateTime
      raise "time must be in form datetime"
    end
    result = @@get_total_page_view.call(pid.to_i, from, to, unique)
    str = result.to_s
    dtor_str(result)
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
