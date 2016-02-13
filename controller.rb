require 'rest-client'
require File.expand_path '../time.rb', __FILE__
require File.expand_path '../weather.rb', __FILE__

class Controller
  def initialize
    @outside = Weather_man.get_weather_zip 30075 # hardcoded !!!
    @sensor = {temp: 45.00, humidity: 32.4}
    @clock = Time_man.new
  end

  def outside
    @clock.time? ? @outside : @outside #second part needs to be changed to database
  end

  def inside
    @clock.time? ? @sensor : @sensor #second part needs to be changed to database
  end

  def img
    ISource.getImg @outside[:temp], @outside[:condition_id]
  end
end
