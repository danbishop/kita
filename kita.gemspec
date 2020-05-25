# frozen_string_literal: true

require_relative 'lib/kita/version'

Gem::Specification.new do |spec|
  spec.name          = 'kita'
  spec.version       = Kita::VERSION
  spec.authors       = ['Dan Bishop']
  spec.email         = ['d@nbishop.uk']
  spec.license       = 'GPLv3+'

  spec.summary       = 'A Japanese kana learning tool.'
  spec.description   = <<-DESC
    A simple GTK3 app to help Japanese language learners with Hiragana and Katakana. It introduces
    users to the sounds of the kana and teaches basic recognition of both writing systems.
  DESC

  spec.homepage      = 'https://www.danbishop.org'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/danbishop/kita'
  spec.metadata['changelog_uri'] = 'https://github.com/danbishop/kita/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'config', '~> 2.2'
  spec.add_runtime_dependency 'gir_ffi', '~> 0.15.2'
  spec.add_runtime_dependency 'gstreamer', '~> 3.4'
  spec.add_runtime_dependency 'gtk3', '~> 3.4'
  spec.add_runtime_dependency 'mojinizer', '~> 0.2.2'
  spec.add_runtime_dependency 'pango', '~> 3.4'
end
