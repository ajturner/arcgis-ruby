# ArcGIS Online Ruby Library

This library is a simple wrapper around the ArcGIS API's for GeoServices and ArcGIS Online using the sharing API.

The library currently just exposes the service endpoints and accepts unverified hashes of input parameters as specified in the [ArcGIS API](http://www.arcgis.com/apidocs/rest/). As it evolves more endpoints will be added as well as more Ruby-like objects for the various API capabilities.



## Instructions

```ruby
# Create a client
@online = Arcgis::Online.new(:host => "http://www.arcgis.com/sharing/rest/")
# Do an unauthenticated search
@results = @online.search(:q => "weather", :itemtype => "Web Map")

# For features with permissions, first log in
@online.login(:username => @username, :password => @password)

# Create an item
@online.add_item( :title => "Weather Station Temperatures",
                  :type => "CSV",
                  :file => File.open("my_data.csv"),
                  :tags  => %w{temperature stations}.join(","))

@id = @response["id"]
puts "This item has #{@response['numComments']} comments."

# Publish as a feature service
analysis = @online.analyze_item(:id => @id, :type => "CSV")
publish = @online.publish_item(:id => @id,
                               :filetype => "Feature Service",
                               :publishParameters => analysis["publishParameters"].to_json)

puts "Feature Service URL: " + publish["services"].first["serviceurl"]

# Clean up
@online.delete_items(:items => [@id, publish["services"].first["serviceItemId"]])
```

### Testing

arcgis-ruby uses RSpec for tests. To run, just run:

    $ rspec

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
