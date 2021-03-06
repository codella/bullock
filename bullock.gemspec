Gem::Specification.new do |s|
  s.name = 'bullock'
  s.version = '0.0.1'
  s.date = '2015-03-21'
  s.summary = "A simple Ruby PEG implementation"
  s.description = "A simple Ruby PEG implementation - no strings attached!"
  s.authors = ["Mauro Codella"]
  s.email = 'mcodella@gmail.com'
  s.homepage = 'http://github.com/codella/bullock'
  s.license = 'apache2'
  s.required_ruby_version = '~> 2.2'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "byebug", "~> 4.0.0"
  s.add_development_dependency "rspec", "~> 3.2.0"
end
