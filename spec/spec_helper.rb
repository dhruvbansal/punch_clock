require 'rspec'

PUNCHCLOCK_ROOT = File.expand_path(__FILE__, '../../lib') unless defined?(PUNCHCLOCK_ROOT)
$: << PUNCHCLOCK_ROOT unless $:.include?(PUNCHCLOCK_ROOT)
require 'punch_clock'
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |path| require path }
include PunchClock
