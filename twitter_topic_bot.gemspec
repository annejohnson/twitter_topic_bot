# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter_topic_bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitter_topic_bot'
  spec.version       = TwitterTopicBot::VERSION
  spec.authors       = ['Anne Johnson']
  spec.email         = ['annecodes@gmail.com']

  spec.summary       = %q{A gem to create Twitter bots that tweet about topics of interest}
  spec.homepage      = 'https://github.com/annejohnson/twitter_topic_bot'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'twitter', '~> 5.16', '>= 5.16.0'
  spec.add_runtime_dependency 'rufus-scheduler', '~> 3.2', '>= 3.2.1'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
