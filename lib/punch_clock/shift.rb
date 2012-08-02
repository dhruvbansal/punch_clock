require 'time'

module PunchClock

  class Shift

    attr_reader :started_at, :ended_at

    def self.parse string
      new(*string.split(";"))
    end

    def to_s
      [started_at, ended_at].map(&:to_s).join(";")
    end

    def initialize *args
      self.started_at = args.shift
      self.ended_at   = args.shift
    end

    def started_at= time
      return if time.nil?
      return if time.is_a?(String) && time.empty?
      t = time.is_a?(Time) ? time : Time.parse(time)
      raise ShiftError.new("#{t} is after this shift's end time #{ended_at}") if ended_at && t > ended_at
      @started_at = t
    end

    def ended_at= time
      return if time.nil?
      return if time.is_a?(String) && time.empty?
      t = time.is_a?(Time) ? time : Time.parse(time)
      raise ShiftError.new("#{t} is before this shift's start time #{started_at}") if started_at && t < started_at
      @ended_at = t
    end

    def started?
      started_at
    end

    def ended?
      ended_at
    end

    def completed?
      started? && ended?
    end
    
    def working?
      started? && (! ended_at)
    end

    def new?
      (! started?) && (! ended?)
    end

    def start!
      raise ShiftError.new("Already started this shift") if started?
      raise ShiftError.new("Already ended this shift")   if ended?
      self.started_at = Time.now
    end
    
    def self.start!
      new.tap { |shift| shift.start! }
    end
    
    def end!
      raise ShiftError.new("Have not started this shift") unless started?
      raise ShiftError.new("Already ended this shift")    if     ended?
      self.ended_at = Time.now
    end

    def == other
      if started_at
        return false unless other.started_at
        return false unless other.started_at.to_i == self.started_at.to_i
      else
        return false unless other.started_at.nil?
      end
      if ended_at
        return false unless other.ended_at
        return false unless other.ended_at.to_i == self.ended_at.to_i
      else
        return false unless other.ended_at.nil?
      end
      true
    end

    def != other
      other.started_at != started_at || other.ended_at != ended_at
    end
    
    def > other
      case
      when ! started? && ! other.started? then false
      when   started? && ! other.started? then true
      when ! started? &&   other.started? then false
      when started_at <= other.started_at then false
      else
        true
      end
    end

    def >= other
      case
      when ! started? && ! other.started? then false
      when   started? && ! other.started? then true
      when ! started? &&   other.started? then false
      when started_at  < other.started_at then false
      else
        true
      end
    end
    
    def < other
      case
      when ! started? && ! other.started? then false
      when   started? && ! other.started? then false
      when ! started? &&   other.started? then true
      when started_at >= other.started_at then false
      else
        true
      end
    end

    def <= other
      case
      when ! started? && ! other.started? then false
      when   started? && ! other.started? then false
      when ! started? &&   other.started? then true
      when started_at >  other.started_at then false
      else
        true
      end
    end
    
    def <=> other
      # -1: I am smaller than other
      #  0: I am equal to other
      #  1: I am greater than other
      case
      when ! started? && ! other.started? then  0
      when   started? && ! other.started? then  1
      when ! started? &&   other.started? then -1
      when started_at < other.started_at  then -1
      when started_at == other.started_at then  0
      else
        1
      end
    end
    
  end
end
