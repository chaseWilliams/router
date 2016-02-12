#flickr.rb
require 'rest-client'

#grabs the image url of a pre-specified photo id using Flickr's API.
module Flickrd
  def imgUrl photo_id
    response = JSON.parse (RestClient.get "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=3a86e2e6e0552b135fa3830f8421d07e&format=json&photo_id=#{photo_id}&nojsoncallback=?")
    img_index = nil #default value

    #determines what's the index of the 'Large' image.
    response['sizes']['size'].each_with_index {|k, i| if k['label'] == 'Large' then img_index = i; break end}
    if img_index.nil? #in case img_index wasn't affected.
      return "https://farm7.staticflickr.com/6217/6357276861_1fdc6fe3d4_b.jpg"
    else
      return response['sizes']['size'][img_index]['source']
    end
  end
  module_function :imgUrl
end
