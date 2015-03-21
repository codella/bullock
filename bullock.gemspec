Gem::Specification.new do |s|
  s.name        = 'bullock'
  s.version     = '0.0.1'
  s.date        = '2015-03-21'
  s.summary     = "A minimal Ruby PEG"
  s.description = "A simple hello world gem"
  s.authors     = ["Mauro Codella"]
  s.email       = 'mcodella@gmail.com'
  s.homepage    = 'http://github.com/codella/bullock'
  s.license     = 'apache2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec", "~> 3.2.0"
end
