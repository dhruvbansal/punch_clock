require 'spec_helper'

describe Shift do
  
  before do
    @start     = Time.now
    @end       = @start + 60
    @new       = Shift.new
    @started   = Shift.new(@start)
    @ended     = Shift.new(nil, @end)
    @completed = Shift.new(@start, @end + 60)
  end
  
  describe "setting start and end times" do

    it "should allow setting a start time" do
      @new.started_at = @start
      expect(@new.started_at).to eql(@start)
    end

    it "should allow setting a start time before an existing end time" do
      @ended.started_at = @start
      expect(@ended.started_at).to eql(@start)
    end

    it "should raise an error when setting a start time after an existing end time" do
      expect { @ended.started_at = @end + 10 }.to raise_error(ShiftError)
    end

    it "should allow setting an end time" do
      @new.ended_at = @end
      expect(@new.ended_at).to eql(@end)
    end

    it "should allows setting an end time after an existing start time" do
      @started.ended_at = @end
      expect(@started.ended_at).to eql(@end)
    end

    it "should raise an error when setting an end time before an existing start time" do
      expect { @started.ended_at = @start - 10 }.to raise_error(ShiftError)
    end
    
  end

  describe "reporting state" do

    it "should know when it has been started" do
      expect(@new.started?).to       be_false
      expect(@started.started?).to   be_true
      expect(@ended.started?).to     be_false
      expect(@completed.started?).to be_true
    end

    it "should know when it has been ended" do
      expect(@new.ended?).to       be_false
      expect(@started.ended?).to   be_false
      expect(@ended.ended?).to     be_true
      expect(@completed.ended?).to be_true
    end

    it "should know when it is working" do
      expect(@new.working?).to       be_false
      expect(@started.working?).to   be_true
      expect(@ended.working?).to     be_false
      expect(@completed.working?).to be_false
    end

    it "should know when it is new" do
      expect(@new.new?).to       be_true
      expect(@started.new?).to   be_false
      expect(@ended.new?).to     be_false
      expect(@completed.new?).to be_false
    end
    
    it "should know when it is completed" do
      expect(@new.completed?).to       be_false
      expect(@started.completed?).to   be_false
      expect(@ended.completed?).to     be_false
      expect(@completed.completed?).to be_true
    end
    
  end

  describe "manipulating state" do
    
    it "should be able to start itself if it is new" do
      expect(@new.started?).to be_false
      @new.start!
      expect(@new.started?).to be_true
    end

    it "should raise an error when starting if it is not new" do
      expect { @started.start! }.to   raise_error(ShiftError)
      expect { @ended.start! }.to     raise_error(ShiftError)
      expect { @completed.start! }.to raise_error(ShiftError)
    end

    it "should be able to end itself if it is working" do
      expect(@started.working?).to be_true
      @started.end!
      expect(@started.working?).to be_false
    end
    
    it "should raise an error when ending if it is not working" do
      expect { @new.end! }.to       raise_error(ShiftError)
      expect { @ended.end! }.to     raise_error(ShiftError)
      expect { @completed.end! }.to raise_error(ShiftError)
    end
    
  end

  describe "comparing shifts" do

    it "should consider any shift equal to itself" do
      expect(@new       == @new).to       be_true
      expect(@started   == @started).to   be_true
      expect(@ended     == @ended).to     be_true
      expect(@completed == @completed).to be_true
    end

    it "should consider shifts in different states as unequal" do
      expect(@new == @started).to be_false
      expect(@new == @ended).to be_false
      expect(@new == @completed).to be_false

      expect(@started == @new).to be_false
      expect(@started == @ended).to be_false
      expect(@started == @completed).to be_false

      expect(@ended == @new).to be_false
      expect(@ended == @started).to be_false
      expect(@ended == @completed).to be_false

      expect(@completed == @new).to be_false
      expect(@completed == @started).to be_false
      expect(@completed == @ended).to be_false
    end

    it "should consider two unstarted shifts as incomparable" do
      expect(@new   > @ended).to be_false
      expect(@ended < @new).to   be_false
      expect(@ended > @new).to   be_false
      expect(@new   < @ended).to be_false
    end

    it "should consider a started shift later than an unstarted shift" do
      expect(@started > @new).to     be_true
      expect(@new     < @started).to be_true
      expect(@started > @ended).to   be_true
      expect(@ended   < @started).to be_true
    end

    it "should consider a started shift later than an unstarted shift" do
      expect(@started > @new).to   be_true
      expect(@started > @ended).to be_true
    end

    it "should consider a shift started after another to be later" do
      expect(Shift.new(@end) > @started).to          be_true
      expect(@started        < Shift.new(@end)).to be_true
    end

    it "can sort arrays of shifts" do
      expect([@new, Shift.new(@end), @started].sort).to eq([@new, @started, Shift.new(@end)])
    end
    
  end
  
  it "should serialize and unserialize itself" do
    expect(Shift.parse(@new.to_s)).to       eq(@new)
    expect(Shift.parse(@started.to_s)).to   eq(@started)
    expect(Shift.parse(@ended.to_s)).to     eq(@ended)
    expect(Shift.parse(@completed.to_s)).to eq(@completed)
  end
  
end


