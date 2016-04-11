var api_url = 'http://router.roswell.apcera-platform.io/?'
new Vue({
  el: '#app',
  data: {
    temp: '',
    cloudiness: '',
    humidity: '',
    windiness: '',
    condition_name: '',
    condition_description: '',
    wiki: '',
    wiki_title: '',
    city: '',
    lat: '',
    lon: '',
    function(){
      return {pic_url: 'https://farm4.staticflickr.com/3933/14919486574_0f94bedf92_b.jpg'}
    }
  },

  computed: {
    background_style: function(){
    return {'background-image': 'url("'+this.pic_url+'")'}
    },
    url_to_wiki: function(){
      var baseurl = 'https://en.wikipedia.org/wiki/'
      var title = this.$get(wiki_title).replace(' ', '_')
      return {'href': '' + baseurl + title}
    }
  },

  created: function () {
    this.get_data();
  },

  methods: {
    get_data: function () {
        var self = this;
        console.log('called')
        console.log('location method called');
        navigator.geolocation.getCurrentPosition(success, error, {maximumAge:60000, timeout:5000, enableHighAccuracy:true});
        console.log('got current position')
        function success(position) {
            console.log('entered success method')
            var latitude = position.coords.latitude;
            var longitude = position.coords.longitude;
            console.log('latitude is ' + latitude)
            console.log("lat" + latitude + 'lon' + longitude);
            self.$set('lat', latitude);
            self.$set('lon', longitude);
            console.log('Set coordinates!' + self.lat + '   ' + self.lon);
            self.fetch_data(self.lat, self.lon);
        }
        function error(err) {
          console.log('errored: ' + err);
          if(err.code == 1) {
           console.log("Error: Access is denied!");
          }
          else if( err.code == 2) {
           console.log("Error: Position is unavailable!");
          }
          self.fetch_data(34, -84);
        }
    },

    fetch_data: function (lat, lon) {
      console.log('in the fetch_data method')
      console.log(lat + ' ' + lon)
      var endpoint = api_url + "lat=" + lat + "&lon=" + lon
      console.log('endpoint is ' + endpoint)
      $.get(endpoint).then(function(data) {
        console.log("Data  is");
        console.log(data)
        //set all of the data to updated weather stats
        var weather = data.weather.data
        console.log("The weather data is ");
        console.log(weather)
        this.$set('pic_url', data.pic.url)
        this.$set('temp', weather.temp)
        this.$set('cloudiness', weather.cloudiness)
        this.$set('humidity', weather.humidity)
        this.$set('windiness', weather.windiness)
        this.$set('condition_name', weather.condition_name)
        this.$set('condition_description', weather.condition_description)
        this.$set('wiki', data.article.extract)
        this.$set('wiki_title', data.article.title)
          console.log("the city is ")
          console.log(weather.city)
        this.$set('city', weather.city)
      }.bind(this));
    }
  }
});
