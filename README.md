# Router
The WeatherMashup app's API- ties together the three proxy microservices. (see:
  [proxy-weather](https://github.com/chaseWilliams/proxy_weather) |
  [proxy-wikipedia](https://github.com/chaseWilliams/proxy_wikipedia) |
  [proxy-flickr](https://github.com/chaseWilliams/proxy_flickr))

__Note: The public folder is for testing and temporary deployment purposes- it brings up a website showing data obtained with the WeatherMashup API, available at the `/example` endpoint.__

To use it, simply perform a GET request at wherever it is deployed with a `lat` and a `lon` params, feeding it the coordinates you wish to obtain information for.
## Getting to Know the Microservices

#### The Weather Proxy

This is the dominant proxy for the app- not only is the data the most useful, but the
completion of acquisition of the other data is dependent on its success.

This proxy sends JSON containing weather information from [OpenWeatherMaps](http://openweathermap.com/). OpenWeatherMap (frequently referred to as `OWM` in the code) was used due to the many cities it supports and its usable free tier. The data will often look like:
 ```
{
  "status": "ok",
  "data": {
    "temp": 77,
    "cloudiness": 1,
    "humidity": 24,
    "windiness": 1.2,
    "condition_id": 800,
    "condition_name": "Clear",
    "condition_description": "clear sky",
    "city": "Knoxville",
    "zipcode": "37912"
  }
}
```
The units are detailed [here](http://openweathermap.org/current#current_JSON). What the condition IDs represent can be interpreted [here](http://openweathermap.org/weather-conditions).

The Weather Proxy supports two endpoints: one that fetches the aforementioned data (can be given either a zipcode or coordinates), and one that returns what OpenWeatherMap gave without any trimming or processing added on.

For caching data (as to not exceed the allotted daily API hit limit), the Redis database system is used, which is a memory-founded key-value DB that's easy to use for these purposes. Note that every proxy uses Redis for caching as well.
#### The Flickr Proxy
In order to provide high-quality pictures that go hand-in-hand with the weather condition, the Flickr service is used. Note that the _pictures_ are not obtained using the Flickr API, but rather links to preselected pictures using their respective photo IDs, which automatically grabs the Large size (1024 x 1024). The returned JSON looks like so:
```
{
  "status": "ok",
  "url": "https://farm1.staticflickr.com/600/23577541545_007c408d75_b.jpg"
}
```
#### The Wikipedia Proxy
The wikipedia proxy makes use of the [MediaWiki API](https://www.mediawiki.org/wiki/API:Main_page). What happens under the hood are two GET requests: one two obtain a short list of articles nearby a given pair of coordinates, and after one of those articles are chosen, another request obtains the actual metadata associated with that chosen article. Then, the post-fetch processing trims down the extract down to the first paragraph (still keeping the inside HTML tags!) and returns the title and extract. An example would be so:
```
{
  "status": "ok",
  "title": "Bulloch Hall",
  "extract": "<p><b>Bulloch Hall</b> is a Greek Revival mansion in Roswell, Georgia, built in 1839. It is one of several historically significant buildings in the city and is listed on the National Register of Historic Places. This is where Martha Bulloch Roosevelt, mother of Theodore Roosevelt, 26th U.S. President, lived as a child. It is also where she married Theodore Roosevelt's father, Theodore Roosevelt, Sr."
}
```
## Deployment
In my case, I created these microsevices on Apcera CE, which gave me huge immensely helpful tools for testing, deploying, maintaining, and microservice cooperation. Apcera's providers and deployment routines mean that with a simple configuration file, a complete container with Ubuntu OS and all the dependencies (and __only__ them) your app needs is erected quickly and efficiently, which is multiplied across the hundreds (hardware allotting) of instances you can create easily.

A `template.continuum.conf` (the configuration file) is in this repo for purposes of quickly setting up this app on your own environment. Templates are also available on the individual proxies' repos, which come with what specific API keys to obtain, routes to set, etc.

To set up this app (assuming you already have Apcera CE installed and a cluster set aside for this):
1. Clone this and the proxy repositories.
2. Make sure you target your cluster (`apc target <your_cluster_url>`)
3. `cd` into each repository and run `apc app create`. The apcera cli should detect the config file and automatically erect the cluster.
4. Start the apps- `apc app start <app_name>`

That's it!
For code changes and redeployment, simply do `apc app deploy` within the app's respective directory. Flag can be passed for additional information, such as `-i` to change the number of instances. Note that deploying won't always fix your issue- some changes, such changing the routes, will require using different cli commands. Also note that there's a web console- changes can be made easily there as well.

[Apcera Documentation](https://docs.apcera.com/)
