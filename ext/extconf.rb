require 'fileutils'
require 'mkmf'
require 'rbconfig'
include FileUtils

def ext
  host_os = RbConfig::CONFIG['host_os']
  case host_os
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    ".dll"
  when /darwin|mac os/
    ".dylib"
  when /linux/
    ".so"
  when /solaris|bsd/
    ".so"
  else
    raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
  end
end

%x(cargo build --release --manifest-path ./keenio-batch/Cargo.toml)

mv("./keenio-batch/target/release/libkeenio_batch" + ext, "../lib/")

create_makefile(".")
