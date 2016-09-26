# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keen-batch/version'
require 'pathname'

Gem::Specification.new do |spec|
  spec.name          = "keen-batch"
  spec.version       = Keen::Batch::VERSION
  spec.authors       = ["Wu Young"]
  spec.email         = ["doomsplayer@gmail.com"]

  spec.summary       = "native library for optimizing keen io delay for strikingly"
  spec.description   = "written in rust"
  spec.homepage      = "http://github.com/doomsplayer/keen-batch.rb.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]
  spec.extensions = ["ext/extconf.rb"]
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  currpath = Pathname.new(File.expand_path("../",__FILE__))


  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|
    # for each submodule, change working directory to that submodule
    Dir.chdir(submodule_path) do
      # issue git ls-files in submodule's directory
      submodule_files = `git ls-files`.split($\)

      # prepend the submodule path to create absolute file paths
      submodule_files_fullpaths = submodule_files.map do |filename|
        "#{submodule_path}/#{filename}"
      end
      # remove leading path parts to get paths relative to the gem's root dir
      # (this assumes, that the gemspec resides in the gem's root dir)
      submodule_files_paths = submodule_files_fullpaths.map do |filename|
        filepath = Pathname.new(filename)
        filepath.relative_path_from(currpath).to_s
      end
      # add relative paths to gem.files
      spec.files += submodule_files_paths
    end
  end
end
