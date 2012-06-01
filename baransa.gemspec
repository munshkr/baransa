# -*- encoding: utf-8 -*-
require File.expand_path('../lib/baransa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Damián Silvani"]
  gem.email         = ["munshkr@gmail.com"]
  gem.description   = %q{Load balancer and limiter written in Ruby}
  gem.summary       = %q{Baransa is a forward proxy with load balancer and
                         limiter written in Ruby, especially designed for
                         massive scraping.}
  gem.homepage      = "https://github.com/sumavisos/baransa"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "baransa"
  gem.require_paths = ["lib"]
  gem.version       = Baransa::VERSION

  gem.add_runtime_dependency "daemons"
  gem.add_runtime_dependency "em-proxy"
  gem.add_runtime_dependency "ansi"
  gem.add_runtime_dependency "rack"
  gem.add_development_dependency "rake"
end
