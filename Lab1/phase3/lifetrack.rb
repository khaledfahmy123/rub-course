require_relative 'event'
require_relative 'event_router'
require_relative 'console_handler'
require_relative 'file_handler'
require_relative 'html_handler'

# --- Wiring (the only place concrete handlers are named) ---
router = EventRouter.new
router.register(ConsoleHandler.new)
router.register(FileHandler.new)
router.register(HtmlHandler.new)

TYPES = {
  '1' => 'WORK',
  '2' => 'STUDY',
  '3' => 'EXERCISE',
  '4' => 'MEAL'
}

puts "\n=== LifeTrack ===\n\n"

loop do
  puts "1. Log a work session"
  puts "2. Log a study session"
  puts "3. Log an exercise session"
  puts "4. Log a meal"
  puts "5. Exit"
  print "\nChoose an option: "

  choice = gets.chomp
  break if choice == '5'

  type = TYPES[choice]
  unless type
    puts "Invalid choice.\n\n"
    next
  end

  print "Description: "
  description = gets.chomp

  print "Duration (minutes): "
  duration = gets.chomp.to_i

  event = LifeEvent.new(type, description, duration, Time.now)
  router.dispatch(event)
  puts
end

puts "\nGoodbye. Dashboard saved to lifetrack_dashboard.html"
