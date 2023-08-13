# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'splendor_game/version'

Gem::Specification.new do |spec|
  spec.name          = "splendor_game"
  spec.version       = SplendorGame::VERSION
  spec.authors       = ["reedstonefood"]
  spec.email         = ["reedstonefood@users.noreply.github.com"]

  spec.summary       = %q{An implementation of the board game, Splendor.}
  spec.homepage      = "https://github.com/reedstonefood/splendor_game"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  
  spec.add_dependency "highline", "~> 2.1"
end
