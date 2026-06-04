require_relative 'handler'

# Observer. Knows only the Handler abstraction — never a concrete class.
class EventRouter
  def initialize
    @handlers = []
  end

  def register(handler)
    raise ArgumentError, "Must be a Handler" unless handler.is_a?(Handler)
    @handlers << handler
  end

  def dispatch(event)
    @handlers.each { |h| h.handle(event) }
  end
end
