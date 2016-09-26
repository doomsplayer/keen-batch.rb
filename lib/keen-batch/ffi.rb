require 'rbconfig'

def os
  host_os = RbConfig::CONFIG['host_os']
  case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
    end
end

module Keen::Batch::FFI
  extend FFI::Library
  ext = ""
  case os
  when :linux, :unix
    ext = 'so'
  when :macosx
    ext = 'dylib'
  when :windows
    ext = 'dll'
  end

  ffi_lib File.expand_path("../../libkeenio_batch.#{ext}", __FILE__)
  attach_function :new_client, [ :string, :string ], :pointer
  attach_function :set_redis, [:pointer, :string], :int
  attach_function :set_timeout, [:pointer, :int], :int

  COUNT = 0
  COUNT_UNIQUE = 1
  # *keenclient, metric_type, metric_target[nil], collection, starttime, endtime
  attach_function :new_query, [:pointer, :int, :string, :string, :string, :string], :pointer
  attach_function :group_by, [:pointer, :string], :int

  EQ = 0
  LT = 1
  GT = 2
  LTE = 3
  GTE = 4
  attach_function :filter, [:pointer, :int, :string, :string], :int

  attach_function :other, [:pointer, :string, :string], :int
  
  MINUTELY = 0
  HOURLY = 1
  DAILY = 2
  attach_function :interval, [:pointer, :int], :int

  POD = 0
  ITEMS = 1
  DAYSPOD = 2
  DAYSITEMS = 4
  attach_function :send_query, [:pointer], :pointer

  # three tranformation calculus
  attach_function :accumulate, [:pointer, :int], :pointer # this will make query object invalid
  attach_function :select, [:pointer, :string, :string, :int], :pointer # this will make query object invalid
  attach_function :range, [:pointer, :string, :string], :pointer # this will make query object invalid
  attach_function :to_redis, [:pointer, :string, :int], :int
  attach_function :to_string, [:pointer], :pointer # this will make result object invalid
  

  attach_function :from_redis, [:string, :string, :int], :pointer
  attach_function :free_string, [:pointer], :void
  attach_function :free_result, [:pointer], :void
  attach_function :free_query, [:pointer], :void
  attach_function :free_client, [:pointer], :void
  attach_function :last_error, [], :pointer

  def check(tg)
    rst = yield tg
    if rst
      ptr = FFI.last_error
      excpt = String.new(ptr.read_string)
      FFI.free_string(ptr)
      raise excpt
    else
      tg
    end
  end
end
