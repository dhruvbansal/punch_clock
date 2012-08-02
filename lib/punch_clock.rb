require 'punch_clock/shift'
require 'punch_clock/clock'
require 'punch_clock/foreman'
require 'punch_clock/report'

module PunchClock
  Error               = Class.new(StandardError)
  ShiftError          = Class.new(Error)
  ClockError          = Class.new(Error)
  CommandError        = Class.new(Error)
  NotImplementedError = Class.new(Error)

  def self.version
    @version ||= begin
      File.read(File.expand_path('../../VERSION', __FILE__)).chomp
    rescue => e
      'unknown'
    end
  end
  
end
