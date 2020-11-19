Container.boot(:logger) do |container|
  init do
    require 'logger'
  end

  start do
    STDOUT.sync = true
    logger = Logger.new(STDOUT)
    container.register(:logger, logger)
  end
end