lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-unicorn"
  gem.version       = '0.0.2'
  gem.authors       = ["Matthew Lineen"]
  gem.email         = ["matthew@lineen.com"]
  gem.description   = "Unicorn specific Capistrano tasks"
  gem.summary       = "Unicorn specific Capistrano tasks"
  gem.homepage      = "https://github.com/mlineen/capistrano-unicorn"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 3.0.0'
end
