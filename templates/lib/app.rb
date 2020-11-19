require 'import'

class App
  include Import['logger']

  def call
    logger.info('starting')
    at_exit do
      logger.info('stopping')
    end
  end
end