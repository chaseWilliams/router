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
    description: master.outside[:condition_description],
    sensor_temp: master.inside[:temp],
    sensor_humidity: master.inside[:humidity],
    background_img: master.img
  }
  puts hash
  hash.each {|key, value| ENV[key.to_s] = value}
  erb :home
end
puts "The master.outside returns #{master.outside.class}"
puts master.outside.values
hash = {
  outside_temp: master.outside[:temp],
  outside_humidity: master.outside[:humidity],
  clouds: master.outside[:cloudiness],
  windiness: master.outside[:windiness],
  id: master.outside[:condition_id],
  name: master.outside[:condition_name],
  description: master.outside[:condition_description],
  sensor_temp: master.inside[:temp],
  sensor_humidity: master.inside[:humidity],
  background_img: master.img
}
hash.each {|key, value| puts "The key #{key} has a class of #{key.class}, while the value #{value} has a class of #{value.class}
Maybe #{"#{key}".class}"}
