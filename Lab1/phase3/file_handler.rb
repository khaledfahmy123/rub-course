require_relative 'handler'

# Single job: append the event to a log file.
class FileHandler < Handler
  LOG_FILE = 'lifetrack.log'

  def handle(event)
    File.open(LOG_FILE, 'a') { |f| f.puts(event.to_s) }
  end
end
