# frozen_string_literal: true

require_relative 'lib/neptuno/version'

Gem::Specification.new do |spec|
  spec.name = 'neptuno'
  spec.version = Neptuno::VERSION
  spec.authors = ['Roberto Plancarte']
  spec.email = ['roberto.plancarte@gmail.com']

  spec.summary = 'Unified Development Environment CLI'
  spec.description = "A CLI for Neptuno distributed architectural style applications"
  spec.homepage = 'https://github.com/apptegy/neptuno'
  spec.license = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.6.1'

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata['homepage_uri'] = "https://apptegy.github.io/neptuno/"
  spec.metadata['source_code_uri'] = "https://github.com/apptegy/neptuno"
  spec.metadata['changelog_uri'] = "https://github.com/apptegy/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Neptuno dependency list
  spec.add_dependency "psych", "< 4"
  spec.add_dependency 'dotiw'
  spec.add_dependency 'dry-cli'
  spec.add_dependency 'hirb'
  spec.add_dependency 'tty-command'
  spec.add_dependency 'tty-config'
  spec.add_dependency 'tty-file'
  spec.add_dependency 'tty-prompt'
  spec.add_dependency 'tty-spinner'
  spec.add_dependency 'tty-which'
  spec.add_dependency 'zeitwerk'

  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'standard'
end
