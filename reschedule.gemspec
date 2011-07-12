# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "reschedule"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wen-Tien Chang"]
  s.email       = ["ihower@gmail.com"]
  s.homepage    = "https://github.com/ihower/reschedule"
  s.summary     = %q{Scheduling calculation using Redis.}
  s.description = %q{a Ruby library using Redis for scheduling calculation.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "redis"
  s.add_development_dependency "rspec", "~> 2.5"
end
