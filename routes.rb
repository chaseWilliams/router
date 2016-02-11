require 'sinatra'
require File.expand_path('../time.rb', __FILE__)

clock = Time_man.new #allows for tiem checks
get '/' do
  # has 10 minutes passed?
  # if !clock.time? 
  # pull old data from MongoDB
  # otherwise, pull the html
   erb :home
end
