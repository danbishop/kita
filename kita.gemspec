# frozen_string_literal: true

require_relative 'lib/kita/version'

Gem::Specification.new do |spec|
  spec.name          = 'kita'
  spec.version       = Kita::VERSION
  spec.authors       = ['Dan Bishop']
  spec.email         = ['d@nbishop.uk']

  spec.summary       = 'A Japanese kana learning tool.'
  spec.description   = 'A simple tool to help Japanese language learners with hiragana and katakana.'
  spec.homepage      = 'https://www.danbishop.org'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/danbishop/kita'
  spec.metadata['changelog_uri'] = 'https://github.com/danbishop/kita/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
