require 'fileutils'
require 'mkmf'
include FileUtils

%x(curl -sf https://raw.githubusercontent.com/doomsplayer/multirust/master/blastoff.sh | sh -s -- --yes)
%x(multirust default nightly-2015-09-28)
%x(echo rustc -v)
%x(git clone https://github.com/doomsplayer/keen_native)
Dir.chdir("keen_native")
%x(cargo build --release)
mv("target/release/libkeen.so", "../../lib/")
mv("target/release/keen", "../../lib/keen")
Dir.chdir("../")
create_makefile(".")
