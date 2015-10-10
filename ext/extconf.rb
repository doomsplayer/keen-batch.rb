require 'fileutils'
require 'mkmf'
include FileUtils

%x(curl -sf https://raw.githubusercontent.com/doomsplayer/multirust/master/blastoff.sh | sh -s -- --yes)
%x(git clone https://github.com/doomsplayer/keen_native)
Dir.chdir("keen_native")
%x(cargo build --release)
mv("target/release/libkeen.so", "../../lib/")
mv("target/release/keen", "../../lib/keen")
Dir.chdir("../")
create_makefile(".")
