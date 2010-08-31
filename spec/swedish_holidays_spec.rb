require File.dirname(__FILE__) + '/../holidays.rb'
require 'ruby-debug'
describe Holidays do
  before(:all) do
    class Date
      include Holidays
    end
    @public_swedish_holidays_2010 = [
      Date.new(2010,1,1),
      Date.new(2010,1,6),
      Date.new(2010,4,2),
      Date.new(2010,4,4),
      Date.new(2010,4,5),
      Date.new(2010,5,1),
      Date.new(2010,5,13),
      Date.new(2010,5,23),
      Date.new(2010,6,6),
      Date.new(2010,6,26),
      Date.new(2010,11,6),
      Date.new(2010,12,25),
      Date.new(2010,12,26)
    ]
    @de_facto_half_swedish_holidays_2010 = [
      Date.new(2010,1,5),
      Date.new(2010,4,1),
      Date.new(2010,4,3),
      Date.new(2010,4,30),
      Date.new(2010,5,12),
      Date.new(2010,11,5)
    ]
    
    @de_facto_full_swedish_holidays_2010 = [
      Date.new(2010,6,25),
      Date.new(2010,12,24),
      Date.new(2010,12,31)
    ]
    
    @swedish_holidays_2010 = [@public_swedish_holidays_2010, @de_facto_half_swedish_holidays_2010, @de_facto_full_swedish_holidays_2010].flatten
  end
  
  it "should mark all public holidays as holidays" do
    @public_swedish_holidays_2010.each do |date|
      date.should be_holiday
    end
  end
  
  it "should mark all de facto half holidays as holidays" do
    @de_facto_half_swedish_holidays_2010.each do |date|
      date.should be_holiday
      date.holiday.should_not be_nil
      date.holiday.should be_de_facto_half
    end
  end
  
  it "should mark all de facto full holidays as holidays" do
    @de_facto_full_swedish_holidays_2010.each do |date|
      date.should be_holiday
      date.holiday.should_not be_nil
      date.holiday.should be_de_facto_full
    end
  end
  
  it "should not list non-holidays as holidays" do
    new_years_day_2010 = Date.new(2010,1,1)
    0.upto(364) do |i|
      date = new_years_day_2010 + i
      next if @swedish_holidays_2010.include?(date)
      
      date.should_not be_holiday
      date.holiday.should be_nil
    end
  end
end