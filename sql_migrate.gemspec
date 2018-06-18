
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sql_migrate/version"

Gem::Specification.new do |spec|
  spec.name          = "sql_migrate"
  spec.version       = SqlMigrate::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["i2bskn@gmail.com"]

  spec.summary       = %q{Schema Migration utilities for MySQL.}
  spec.description   = %q{Schema Migration utilities for MySQL.}
  spec.homepage      = "https://github.com/i2bskn/sql_migrate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "mysql2"
end
