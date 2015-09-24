$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rails-carrierwave-focuspoint/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails-carrierwave-focuspoint'
  s.version     = RailsCarrierwaveFocuspoint::VERSION
  s.authors     = ['evg2108']
  s.email       = ['evg2108@yandex.ru']
  # s.homepage    = 'https://github.com/evg2108/rails-carrierwave-focusprint'
  s.summary     = 'CarrierWave extension for specifying focus point on image before they upload on server and cropped.'
  s.description = 'CarrierWave extension for specifying focus point on image before they upload on server and cropped.'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(MIT-LICENSE Rakefile README.md)

  s.add_dependency 'rails', '~> 3.2.21'
  # s.add_dependency 'jquery-rails'
end
