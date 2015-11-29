require "keen_native/version"
require 'time'
require "ffi"
require "keen_native/ffi"
require "keen_native/types"
require "keen_native/result"
require "keen_native/query"
require "keen_native/client"

module KeenNative
  def self.enable_log
    KeenIoBooster.enable_log
  end
end


