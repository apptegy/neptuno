# frozen_string_literal: true

require_relative "lib/ude/version"

Gem::Specification.new do |spec|
  spec.name = "ude"
  spec.version = UDE::VERSION
  spec.authors = ["Roberto Plancarte"]
  spec.email = ["roberto.plancarte@apptegy.com"]

  spec.summary = "Unified Development Environment CLI"
  spec.description = "A CLI for Roberto Plancarte's UDE architectural style"
  spec.homepage = "https://github.com/robertoplancarte/ude.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.2"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # UDE dependency list
  spec.add_dependency "dry-cli"
  spec.add_dependency "tty-command"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "standard"
end
