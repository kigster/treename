# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/treename/version'

Gem::Specification.new do |spec|
  spec.name    = 'treename'
  spec.version = TreeName::VERSION
  spec.authors = ['Konstantin Gredeskoul']
  spec.email   = %w(kigster@gmail.com)

  spec.summary = "Extensible CLI helper client for Github, for automating various tasks, such as — generating a list of org's repos and converting it into a pretty markdown, etc"
  spec.license = 'MIT'

  spec.description = "Generate repository list, show user info and more."

  spec.homepage = 'https://github.com/kigster/treename'

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'colored2', '~> 3'
  spec.add_dependency 'dry-cli', '~> 0.6'
  spec.add_dependency 'octokit', '~> 4'
  spec.add_dependency 'tty-box', '~> 0.5'
  spec.add_dependency 'tty-cursor'
  spec.add_dependency 'tty-progressbar'
  spec.add_dependency 'tty-screen'

  spec.add_development_dependency 'aruba', '= 1.0.0'
  spec.add_development_dependency 'awesome_print', '~> 1'
  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'relaxed-rubocop'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec-its', '~> 1'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-formatter-badge'
end