module PunchClock

  class Report

    attr_accessor :clock

    def initialize clock
      self.clock = clock
    end

    def draw!
      raise NotImplementedError.new("Sorry, haven't written the code to draw your punch clock yet.")
    end

  end
end

