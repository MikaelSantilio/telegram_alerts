# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/telegram_alerts/version'

Gem::Specification.new do |spec|
  spec.name          = 'telegram_alerts'
  spec.version       = TelegramAlerts::VERSION
  spec.authors       = ['mikael']
  spec.email         = ['mikael.santilio@gmail.com']

  spec.summary       = 'Telegram Alerts'
  spec.description   = 'A Ruby gem that allows you to receive notifications about exceptions and alerts in your Ruby applications through Telegram.'
  spec.homepage      = 'https://github.com/MikaelSantilio/telegram_alerts'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/MikaelSantilio/telegram_alerts'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

end
