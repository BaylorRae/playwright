# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playwright/version'

Gem::Specification.new do |spec|
  spec.name          = "playwright"
  spec.version       = Playwright::VERSION
  spec.authors       = ["Baylor Rae'"]
  spec.email         = ["baylor@fastmail.com"]

  spec.summary       = %q{Playwright is a foundational piece for building a test framework.}
  spec.description   = %q{Playwright is a foundational piece for building a test framework.}
  spec.homepage      = "https://github.com/baylorrae/playwright"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
