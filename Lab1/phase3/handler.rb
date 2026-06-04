# Shared interface. Every output must implement handle(event).
# A class that forgets gets a loud runtime error — never silent.
class Handler
  def handle(event)
    raise NotImplementedError, "#{self.class}#handle is not implemented"
  end
end
