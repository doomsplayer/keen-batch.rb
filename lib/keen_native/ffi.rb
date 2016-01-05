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

module KeenIoBooster
  extend FFI::Library
  ext = ""
  case os
  when :linux
    ext = 'so'
  when :unix
    ext = 'so'
  when :macosx
    ext = 'dylib'
  when :windows
    ext = 'dll'
  end

  ffi_lib File.expand_path('../../libkeenio_booster.#{ext}', __FILE__)
  attach_function :new, [ :string, :string ], :pointer
  attach_function :set_redis, [:pointer, :string], :int
  attach_function :set_timeout, [:pointer, :int], :int

  COUNT = 0
  COUNT_UNIQUE = 1
  # *keenclient, metric_type, metric_target[nil], collection, starttime, endtime
  attach_function :query, [:pointer, :int, :string, :string, :string, :string], :pointer
  attach_function :group_by, [:pointer, :string], :int

  EQ = 0
  LT = 1
  GT = 2
  LTE = 3
  GTE = 4
  attach_function :filter, [:pointer, :int, :string, :string], :int

  MINUTELY = 0
  HOURLY = 1
  DAILY = 2
  attach_function :interval, [:pointer, :int], :int

  POD = 0
  ITEMS = 1
  DAYSPOD = 2
  DAYSITEMS = 4
  attach_function :data, [:pointer, :int], :pointer # this will make query object invalid

  # three tranformation calculus
  attach_function :accumulate, [:pointer, :int], :pointer # this will make query object invalid
  attach_function :select, [:pointer, :string, :string, :int], :pointer # this will make query object invalid
  attach_function :range, [:pointer, :string, :string], :pointer # this will make query object invalid
  attach_function :to_redis, [:pointer, :string, :int], :int
  attach_function :result_data, [:pointer], :pointer # this will make result object invalid

  attach_function :from_redis, [:string, :string, :int], :pointer
  attach_function :dealloc_str, [:pointer], :void
  attach_function :delete_result, [:pointer], :void
  attach_function :enable_log, [], :void
end
