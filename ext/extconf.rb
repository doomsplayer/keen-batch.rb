require 'fileutils'
require 'mkmf'
require 'rbconfig'
include FileUtils
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

%x(cargo build --release --manifest-path ./keen_native/Cargo.toml)
case os
  when :linux
    mv("./keen_native/target/release/libkeenio_booster.so", "../lib/")
  when :unix
    mv("./keen_native/target/release/libkeenio_booster.so", "../lib/")
  when :macosx
    mv("./keen_native/target/release/libkeenio_booster.dylib", "../lib/")
  when :windows
    mv("./keen_native/target/release/libkeenio_booster.dll", "../lib/")
  end

create_makefile(".")
