require 'sinatra'
require File.expand_path '../controller.rb', __FILE__

master = Controller.new
get '/' do
  hash = {
    outside_temp: master.outside[:temp],
    outside_humidity: master.outside[:humidity],
    clouds: master.outside[:cloudiness],
    windiness: master.outside[:windiness],
    id: master.outside[:condition_id],
    name: master.outside[:condition_name],
    weather_img: master.outside[:condition_img],
    description: master.outside[:condition_description],
    sensor_temp: master.inside[:temp],
    sensor_humidity: master.inside[:humidity],
    background_img: master.img
  }
  puts hash
  #hash.each {|key, value| ENV[key.to_s] = value.to_s}
  erb :home, locals: hash
end
hash = {
  outside_temp: master.outside[:temp],
  outside_humidity: master.outside[:humidity],
  clouds: master.outside[:cloudiness],
  windiness: master.outside[:windiness],
  id: master.outside[:condition_id],
  name: master.outside[:condition_name],
  weather_img: master.outside[:condition_img],
  description: master.outside[:condition_description],
  sensor_temp: master.inside[:temp],
  sensor_humidity: master.inside[:humidity],
  background_img: master.img
}
puts hash
