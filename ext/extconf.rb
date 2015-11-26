require 'fileutils'
require 'mkmf'
include FileUtils

%x(curl -sf https://raw.githubusercontent.com/doomsplayer/multirust/master/blastoff.sh | sh -s -- --yes)
print %x(multirust override beta), "\n"
print %x(echo rustc -v), "\n"
Dir.chdir(File.expand_path("../keen_native", __FILE__))
print %x(cargo build --release), "\n"
mv("target/release/libkeenio_booster.so", "../../lib/")
Dir.chdir("../")
create_makefile(".")
