require "keen_native/version"
module KeenNative
  require 'fiddle'
  libkeen = Fiddle.dlopen(File.dirname(__FILE__) + '/libkeen.so')
  @@keenget = Fiddle::Function.new(
    libkeen['get'],
    [Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  @@keen_dealloc_str = Fiddle::Function.new(
    libkeen['dealloc_str'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOID
    )
  def self.get_data(url, pid, from_time)
    @@keenget.call(url, pid, from_time)
  end
  def self.dealloc_string(s)
    @@keen_dealloc_str.call(s)
  end
end
