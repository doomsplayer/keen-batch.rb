module KeenIoBooster
  extend FFI::Library
  ffi_lib File.expand_path('../../libkeenio_booster.so', __FILE__)
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
  attach_function :accumulate, [:pointer, :int], :pointer
  attach_function :select, [:pointer, :string, :string, :int], :pointer
  attach_function :to_redis, [:pointer, :string, :int], :int
  attach_function :result_data, [:pointer], :pointer # this will make result object invalid
  
  attach_function :from_redis, [:string, :string, :int], :pointer
  attach_function :dealloc_str, [:pointer], :void
end
