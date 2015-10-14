require "keen_native/version"
require 'eventmachine'
require 'fiddle'
require 'time'

module KeenNative
  libkeen = Fiddle.dlopen(File.dirname(__FILE__) + '/libkeen_native.so')
  @@cache_with_field = Fiddle::Function.new(
    libkeen['cache_with_field_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def cache_with_field(pfrom, pto, field, from, to)
    result = @@cache_with_field.call(pfrom, pto, field, from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_with_field = Fiddle::Function.new(
    libkeen['get_with_field_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def get_with_field(pid, pfrom, pto, field, from, to)
    result = @@get_with_field.call(pib, pfrom, pto, field, from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@cache_unique_page_view = Fiddle::Function.new(
    libkeen['cache_unique_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def cache_unique_page_view(pfrom, pto, from, to)
    result = @@cache_unique_page_view.call(pfrom, pto, from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_unique_page_view = Fiddle::Function.new(
    libkeen['get_unique_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def get_unique_page_view(pid, pfrom, pto, from, to)
    result = @@get_unique_page_view.call(pid, pfrom, pto, from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@cache_total_page_view = Fiddle::Function.new(
    libkeen['cache_total_page_view_c'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def cache_total_page_view(from, to)
    result = @@cache_total_page_view.call(from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_total_page_view = Fiddle::Function.new(
    libkeen['get_total_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def get_total_page_view(pid, from, to)
    result = @@get_total_page_view.call(pid, from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@cache_total_unique_page_view = Fiddle::Function.new(
    libkeen['cache_total_unique_page_view_c'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def cache_total_unique_page_view(from, to)
    result = @@cache_total_unique_page_view.call(from, to)
    str = result.to_s
    dtor_str(result)
    str
  end

  @@get_total_unique_page_view = Fiddle::Function.new(
    libkeen['get_total_unique_page_view_c'],
    [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  def get_total_unique_page_view(pid, from, to)
    result = @@get_total_unique_page_view.call(pid, from, to)
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
