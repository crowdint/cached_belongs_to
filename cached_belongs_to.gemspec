# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cached_belongs_to/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Padilla"]
  gem.email         = ["david@crowdint.com"]
  gem.description   = %q{Denormalize your belongs_to associations}
  gem.summary       = %q{Denormalize your belongs_to associations}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cached_belongs_to"
  gem.require_paths = ["lib"]
  gem.version       = CachedBelongsTo::VERSION

  gem.add_dependency 'activerecord', '~> 3.2'

  gem.add_development_dependency 'autotest'
  gem.add_development_dependency 'autotest-growl'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
