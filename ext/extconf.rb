require 'fileutils'
require 'mkmf'
include FileUtils

%x(curl -sf https://raw.githubusercontent.com/doomsplayer/multirust/master/blastoff.sh | sh -s -- --yes)
print %x(multirust default nightly-2015-10-03), "\n"
print %x(echo rustc -v), "\n"
Dir.chdir("keen_native")
print %x(cargo build --release), "\n"
mv("target/release/libkeen_native.so", "../../lib/")
Dir.chdir("../")
create_makefile(".")
