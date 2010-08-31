class Holiday
  attr_reader :name, :identifier, :de_facto, :conditions, :locale
  
  def initialize(args)
    @name       = args[:name]
    @identifier = args[:identifier]
    @de_facto   = args[:de_facto] || false
    @conditions = args[:conditions]
  end
  
  def de_facto_full?
    self.de_facto == "full"
  end
  
  def de_facto_half?
    self.de_facto == "half"
  end
  
  def de_facto?
    self.de_facto != false
  end
end

module Holidays
  require 'yaml'
  
  @@holidays = {:public => [], :de_facto_full => [], :de_facto_half => []}
  
  YAML.load(File.read(File.dirname(__FILE__) + "/locales/sv.yml")).map do |k,v|
    case v["de_facto"]
    when "full"
      @@holidays[:de_facto_full] << Holiday.new(:identifier => k, 
                                                :name => v["name"], 
                                                :conditions => eval(v["conditions"]),
                                                :de_facto => v["de_facto"])
                                                
    when "half"
      @@holidays[:de_facto_half] << Holiday.new(:identifier => k, 
                                                :name => v["name"], 
                                                :conditions => eval(v["conditions"]),
                                                :de_facto => v["de_facto"])
    else
      @@holidays[:public] << Holiday.new(:identifier => k, 
                                                :name => v["name"], 
                                                :conditions => eval(v["conditions"]))
    end
      
    
  end

  def holiday
    Holidays.all_holidays.each do |h|
      return h if h.conditions.call(self)
    end
    return nil
  end
  
  def holiday?
    !!holiday
  end
  
  # Ruby interpretation of Donald Knuth's code for calculating easter sunday
  # See http://sv.wikipedia.org/wiki/P%C3%A5skdagen#Algoritm_f.C3.B6r_p.C3.A5skdagen for original code
  def Holidays.easter(year = nil)
    year ||= Time.now.year

    g = (year % 19) + 1
    c = (year / 100) + 1
    x = (3 * c) / 4 - 12
    z = (8 * c + 5) / 25 - 5
    d = (5 * year) / 4 - x - 10
    e = (11 * g + 20 + z - x) % 30

    e += 1 if(e == 24 || (e == 25 && g > 11))

    n = 44 - e

    n += 30 if n < 21
    n += 7 - (d + n) % 7

    Date.new(year, 3 + n / 31, n % 31)
  end
  
  def Holidays.de_facto_holidays(full = true)
    @@holidays[(full ? :de_facto_full : :de_facto_half)]
  end
  
  def Holidays.public_holidays
    @@holidays[:public]
  end
  
  def Holidays.all_holidays
    [@@holidays[:public], @@holidays[:de_facto_half], @@holidays[:de_facto_full]].flatten
  end
end
