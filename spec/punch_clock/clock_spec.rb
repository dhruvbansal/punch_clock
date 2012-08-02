require 'spec_helper'

describe Clock do
  
  before do
    @first   = Time.now - 3600
    @second  = @first + 60
    @third   = @first + 120
    @rest    = Clock.new([Shift.new(@first, @first + 10), Shift.new(@second, @second + 10)])
    @working = Clock.new([Shift.new(@first, @first + 10), Shift.new(@second, @second + 10), Shift.new(@third)])
  end

  it "should know when its working" do
    expect(@rest.working?).to    be_false
    expect(@working.working?).to be_true
  end

  it "should allow punching into a new shift when at rest" do
    expect(@rest.working?).to be_false
    @rest.punch_in!
    expect(@rest.changed?).to be_true
    expect(@rest.working?).to be_true
  end

  it "should raise an error when punching into a working clock" do
    expect { @working.punch_in! }.to raise_error(ShiftError)
  end

  it "should allow punching out of a working shift" do
    expect(@working.working?).to be_true
    @working.punch_out!
    expect(@working.changed?).to be_true
    expect(@working.working?).to be_false
  end
  
  it "should raise an error when punching out of a clock at rest" do
    expect { @rest.punch_out! }.to raise_error(ShiftError)
  end

  it "should serialize into and out of a human-readable string" do
    expect(Clock.parse(@rest.to_s)).to    eq(@rest)
    expect(Clock.parse(@working.to_s)).to eq(@working)
  end
  
end

