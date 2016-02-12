#weather.rb
require 'rest-client'
require File.expand_path('../flickr.rb', __FILE__)
include Flickrd

#this module allows for a weather data fetch, supplied via the getWeather method.
module Weather_man
  def self.getWeather cityID
    response = openweathermap "id=#{cityID}"
    weather_data = {
      temp: (1.8*(response['main']['temp'].to_f-273)+32).round,
      cloudiness: response['clouds']['all'].to_f.round,
      humidity: response['main']['humidity'].to_f.round,
      windiness: response['wind']['speed'].to_f.round(1),
      condition_id: response['weather'][0]['id'].to_i,
      condition_name: response['weather'][0]['main'],
      condition_description: response['weather'][0]['description'],
      condition_img: response['weather'][0]['icon']
    }
    return weather_data
  end

  def self.get_weather_zip zip_code
    response = openweathermap "zip=#{zip_code}"
    weather_data = {
      temp: (1.8*(response['main']['temp'].to_f-273)+32).round,
      cloudiness: response['clouds']['all'].to_f.round,
      humidity: response['main']['humidity'].to_f.round,
      windiness: response['wind']['speed'].to_f.round(1),
      condition_id: response['weather'][0]['id'].to_i,
      condition_name: response['weather'][0]['main'],
      condition_description: response['weather'][0]['description'],
      condition_img: response['weather'][0]['icon']
    }
    return weather_data
  end

  def self.openweathermap params
    return JSON.parse RestClient.get 'http://api.openweathermap.org/data/2.5/weather?' + params + '&APPID=bd43836512d5650838d83c93c4412774'
  end

  class << self
    private :openweathermap
  end
end
#Seperated methods into 2 methods because of instance variable complication-
#was getting conversions into NilClass.
#ISource (Image Source) allows for a fetch of a image url that applies to a
#specific weather condition: rain, snow, temperature, etc.
module ISource
  extend Weather_man
  #photo IDs for the images used- can be easily expanded.
  @cold = [23577541545]
  @fog = [8469962417, 14919486574]
  @snow = [89074472]
  @cool = [12043895515, 20342715613 ]
  @warm = [3704273935, 3780893961, 16021074821, 6357276861]
  @hot = [23959664094, 9557006394, 16391611278, 8248259072]
  @really_hot = [19656910812, 5951751285]
  @rain = [6845995798, 9615537120, 6133720797, 15274211811]
  def getImg(temp) #compares with weather condition codes
    #weather conditions first; highest priority.
    if (Weather_man.getWeather(4219934)[:condition_id] >= 200 && Weather_man.getWeather(4219934)[:condition_id] < 600) #rain?
      return imgUrl @rain[rand(@rain.length)-1]
    elsif Weather_man.getWeather(4219934)[:condition_id] >= 600 && Weather_man.getWeather(4219934)[:condition_id] < 700 #snow?
      return imgUrl @snow[rand(@snow.length)-1]
    elsif ([701, 721, 741].each {|k| k == Weather_man.getWeather(4219934)[:condition_id]}) #fog?
      return imgUrl @fog[rand(@fog.length)-1]
    elsif temp <= 10 #cold?
      return imgUrl @cold[rand(@cold.length)-1] #this mechanism returns a random photo id from the array.
    elsif temp <= 40 #cool?
      return imgUrl @cool[rand(@cool.length)-1]
    elsif temp <= 75 #warm?
      return imgUrl @warm[rand(@warm.length)-1]
    elsif temp <= 100#hot?
      return imgUrl @hot[rand(@hot.length)-1]
    else #probably really hot then.
      return imgUrl @really_hot[rand(@really_hot.length)-1]
    end
  end
  module_function :getImg
end
