module PunchClock

  class Clock

    attr_accessor :shifts

    def initialize shifts=[]
      @changed = false
      self.shifts = shifts
    end

    def self.parse string
      new(string.chomp.split("\n").map { |shift_string| Shift.parse(shift_string) }.sort)
    end

    def to_s
      shifts.map(&:to_s).join("\n")
    end
    
    def working?
      shift && shift.working?
    end

    def shift
      shifts.last
    end

    def punch_in!
      raise ShiftError.new("Already working") if working?
      self.shifts << Shift.start!
      @changed = true
    end

    def punch_out!
      raise ShiftError.new("Not working") unless working?
      shift.end!
      @changed = true
    end

    def status
      working? ? "Working" : "Not working"
    end

    def add! shift
      raise ShiftError.new("Added shifts must be completed.") unless shift.completed?
      index = shifts.find_index do |existing_shift|
        existing_shift > shift
      end
      shifts.insert((index || -1), shift)
      @changed = true
    end

    def changed?
      @changed
    end

    def == other
      shifts == other.shifts
    end
    
  end
end
