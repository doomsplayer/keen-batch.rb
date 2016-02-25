require 'fileutils'
require 'mkmf'
include FileUtils

%x(curl -sf https://static.rust-lang.org/rustup.sh | sudo sh -s -- --yes)

Dir.chdir(File.expand_path("../keen_native", __FILE__))
print %x(cargo build --release), "\n"
mv("target/release/libkeenio_booster.so", "../../lib/")
Dir.chdir("../")
create_makefile(".")
