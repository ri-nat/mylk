# frozen_string_literal: true

require_relative "lib/mylk/version"

Gem::Specification.new do |spec|
  spec.name = "mylk"
  spec.version = Mylk::VERSION
  spec.authors = ["Rinat Shaykhutdinov"]
  spec.email = ["mail@rinatshay.com"]

  spec.summary = "SurrealDB client for Ruby (HTTP and WebSocket)"
  spec.homepage = "https://github.com/ri-nat/mylk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ri-nat/mylk"
  spec.metadata["changelog_uri"] = "https://github.com/ri-nat/mylk/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "websocket-client-simple", "~> 0.6"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rbs", "~> 2.8"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
