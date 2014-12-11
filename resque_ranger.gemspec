
Gem::Specification.new do |s|
  s.name        = 'resque_ranger'
  s.version     = '1.0.0.alpha.2'
  s.date        = '2014-12-11'
  s.summary     = "Rake tasks and such for Resque"
  s.description = "Rake tasks and such for Resque"
  s.authors     = ["Brian Lauber"]
  s.email       = 'constructible.truth@gmail.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"

  s.add_dependency "resque", "~> 1.25"
end

