# ArcGIS Online Ruby Library

This library is a simple wrapper around the ArcGIS API's for GeoServices and ArcGIS Online using the sharing API.

The library currently just exposes the service endpoints and accepts unverified hashes of input parameters as specified in the [ArcGIS API](http://www.arcgis.com/apidocs/rest/). As it evolves more endpoints will be added as well as more Ruby-like objects for the various API capabilities.



## Instructions

```ruby

# Simple usage
results = Arcgis::Online.search(q: "weather", itemtype: "Web Map")
item = Arcgis::Online.item(id: 'd6b52a4540b747b09884d738b44a00d2')

# Create a client
Arcgis::Online.login(host: "http://www.arcgis.com/sharing/rest/", 
                                username: @username, 
                                password: @password )

# Do an authenticated search
results = Arcgis::Online.search(q: "weather", itemtype: "Web Map")

# Create an item
item = Arcgis::Online::Item.new( title: "Weather Station Temperatures",
                  type: "CSV",
                  file: File.open("my_data.csv"),
                  tags: %w{temperature stations}.join(","))

puts "This item has #{item.numComments]} comments."

# Publish as a feature service - returns a new item (yeah...)
service_item = item.publish(filetype: "Feature Service",
                               publishParameters: analysis["publishParameters"].to_json)

puts "Feature Service URL: " + service_item.services.first.serviceUrl

# Clean up
service_item.delete
item.delete

```

### Testing

arcgis-ruby uses RSpec for tests. First copy @config.yml.example@ to @config.yml@ and modify the username and password. Then from the command line run:

    $ rspec

If your arcgis online user is a public user, i.e. not allowed to create groups or publish items, then run:

    $ rspec --tag ~@privileged 

This will skip tests that require publisher access.


## Requirements

* Ruby

## Resources

* [ArcGIS Portal API](http://www.arcgis.com/apidocs/rest/)

## Licensing
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

A copy of the license is available in the repository's [license.txt](./license.txt) file.

[](Esri Tags: ArcGIS Ruby API AGOL Public)
[](Esri Language: Ruby)
