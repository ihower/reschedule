require 'reschedule'

describe Reschedule do

  before do
    Reschedule.setup(Redis.new, 3) # 3 seconds 
    @day_7_4 = Reschedule::Day.new("clinic_1", 2011,7,4)
    @day_7_4.current_time = Time.utc(2011,7,4,0,0,0)
  end
  
  after do
    @day_7_4.clean
  end

  describe ".exists?" do
    it "should return true if the date is not expired" do      
      @day_7_4.exists?.should be_true
    end
    
    it "should return false if the date is expired" do      
      @day_7_4.current_time = Time.utc(2011,7,4,0,0,3)
      @day_7_4.exists?.should be_false
    end    
  end
  
  describe ".available?" do
    it "should return false by default" do
      @day_7_4.available?(10,22).should be_false
      @day_7_4.available?(22,11, 30).should be_false
    end
    
    it "should raise NoRuleError if all data are expired" do
      @day_7_4.current_time = Time.utc(2011,7,4,0,0,3)
      lambda{ @day_7_4.available?(10,0) }.should raise_error Reschedule::NoRuleError
    end
    
    example "assign open time" do
      @day_7_4.open(8,0, 60*8) # 8 ~ 16 is open
      
      @day_7_4.available?(7,30, 30).should be_false
      @day_7_4.available?(7,59, 1).should be_false
      
      @day_7_4.available?(8,0).should be_true
      @day_7_4.available?(8,1).should be_true      
      @day_7_4.available?(15,30, 29).should be_true
      @day_7_4.available?(15,30, 30).should be_true
      
      @day_7_4.available?(15,30, 31).should be_false            
      @day_7_4.available?(16,0).should be_false
    end
    
    example "assign open and close time" do
      @day_7_4.open(8,0, 60*8) # 8 ~ 16 is open
      @day_7_4.close(12,0, 60) # 12 ~ 13 is closed
      
      @day_7_4.available?(11,30, 30).should be_true
      
      @day_7_4.available?(11,30, 31).should be_false
      @day_7_4.available?(12,0, 30).should be_false
      @day_7_4.available?(12,0, 60).should be_false
      @day_7_4.available?(12,0, 61).should be_false
      
      @day_7_4.available?(13,0).should be_true    
    end
  end
  
  describe ".clean" do
    it "should clean data" do
      @day_7_4.open(8,0,1)
      @day_7_4.available?(8,0).should be_true
      @day_7_4.clean
      @day_7_4.available?(8,0).should be_false
    end
  end
  
end