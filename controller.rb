require 'rest-client'
require 'redis'
require File.expand_path '../time.rb', __FILE__
require File.expand_path '../weather.rb', __FILE__

class Controller
  def initialize identifier, mode
    @identifier = identifier
    @mode = mode
    @db = Redis.new
    @sensor = {temp: 45.00, humidity: 32.4} # hardcoded ! ! !
    new_data
    @db.expire 'weather_data', 600
    @db.save

  end

  def outside
    #@clock.time? ? @outside : @outside #second part needs to be changed to database
    JSON.parse(@db.get('weather_data'))['outside']

  end

  def inside
    @clock.time? ? @sensor : @sensor #second part needs to be changed to database
  end

  def img
    ISource.getImg @outside[:temp], @outside[:condition_id]
  end

  private
  def new_data
    if @mode == 'zip'
      downloaded = Weather_man.get_weather_zip @identifier
    else
      downloaded = Weather_man.get_weather @identifier
    end
    data = {
      outside: downloaded,
      sensor: @sensor_data,
      time_stamp: Time.now
    }
    @db.set 'weather_data', data.to_json
  end
end

c = Controller.new 30075, 'zip'
puts c.outside
