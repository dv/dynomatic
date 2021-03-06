
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dynomatic/version"

Gem::Specification.new do |spec|
  spec.name          = "dynomatic"
  spec.version       = Dynomatic::VERSION
  spec.authors       = ["David Verhasselt"]
  spec.email         = ["david@crowdway.com"]

  spec.summary       = %q{Gem to autoscale Heroku worker dynos based on number of pending jobs}
  spec.description   = %q{Gem to autoscale Heroku worker dynos based on number of pending jobs}
  spec.homepage      = "https://github.com/dv/dynomatic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activejob"
  spec.add_dependency "activesupport"
  spec.add_dependency "platform-api"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "delayed_job"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
