require_relative 'handler'

# Single job: print the event to the terminal.
class ConsoleHandler < Handler
  def handle(event)
    puts "\n#{event}"
    puts "✓ Event logged."
  end
end
