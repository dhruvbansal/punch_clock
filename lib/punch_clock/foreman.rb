require 'tempfile'

module PunchClock
  class Foreman

    attr_accessor :path, :clock

    def initialize path
      self.path  = path
    end

    def say obj
      puts obj.to_s
    end

    def self.note obj
      $stderr.puts obj.to_s
    end

    def note obj
      self.class.note obj
    end
    
    def start_clock!
      begin
        self.clock = Clock.parse(File.read(path))
      rescue => e
        raise ClockError.new("Could not start clock at #{path}: #{e.message} (#{e.class})")
      end
    end

    def stop_clock!
      begin
        save_clock! if clock.changed?
      rescue => e
        raise ClockError.new("Could not stop clock at #{path}: #{e.message} (#{e.class})")
      end
    end

    def save_clock!
      tmp = Tempfile.new("punch_clock")
      tmp.write(clock.to_s)
      tmp.close
      FileUtils.cp(path, backup_path)
      FileUtils.mv(tmp.path, path)
    end

    def backup_path
      return Tempfile.new.path unless path
      File.join(File.dirname(path), ".#{File.basename(path)}.bak")
    end

    def run! argv
      begin
        execute! argv
      rescue Error => e
         note e.message
      end
    end

    def execute! argv
      cmd = argv.join(' ').strip
      case cmd
      when /^$/     then say clock.status        
      when /^in$/   then clock.punch_in!
      when /^out$/  then clock.punch_out!
      when /^show$/ then say clock
      when /^add\s+(\S+)$/
        clock.add!(Shift.parse($1))
      when /^add$/
        raise CommandError.new("To add a shift pass an additional argument like `2012-07-27 13:37:56 -0500;2012-07-27 13:38:08 -0500'")
      when /^version$/
        say PunchClock.version
      when /^draw$/
        Report.new(clock).draw!
      else
        raise CommandError.new("Unknown command: #{cmd}")
      end
    end

    def self.start! path, argv
      begin
        new(path).tap do |foreman|
          foreman.start_clock!
          foreman.run! argv
          foreman.stop_clock!
        end
      rescue Error => e
        note e.message
      end
    end
  end
end
