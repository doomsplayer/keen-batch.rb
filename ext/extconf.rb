require 'fileutils'
require 'mkmf'
include FileUtils
%x(cargo build --release --manifest-path ./keen_native/Cargo.toml)
mv("./keen_native/target/release/libkeenio_booster.so", "../lib/")
create_makefile(".")
