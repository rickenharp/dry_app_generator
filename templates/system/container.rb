require 'dry/system/container'

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('APPLICATION_ENV', 'development').to_sym }
  configure do |config|
    config.root = Pathname(File.dirname(__FILE__)).join('..')
    config.auto_register = ['lib']
  end
  load_paths!('lib', 'system')

  def self.env
    config.env
  end
end
