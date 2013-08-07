require 'uri'
module Arcgis
  module Sharing
    module Search
      include Arcgis
      
      # q  Description: The query string to search with. 
# 
#       Example: q=relands+map
#       bbox  
#       Description: The bounding box for a spatial search and is defined as minx, miny, maxx, maxy. Search requires q, bbox or both.
# 
#       Spatial search is an overlaps/intersects function of the query bbox and the extent of the document.
# 
#       Documents that have no extent (e.g., mxds, 3dds, lyr) will not be found when doing a bbox search.
# 
#       Document extent is assumed to be in the WGS84 geographic coordinate system.
# 
#       Example: bbox=-118,32,-116,34
# 
#       start  Description: The number of the first entry in the result set response. The index number is 1-based. 
# 
#       The default value of start is 1. (i.e. the first search result) 
# 
#       The start parameter, along with the num parameter can be used to paginate the search results. 
# 
#       Example: start=11 (return result #11 as the first entry in the response)
#       num  Description: The maximum number of results to be included in the result set response. 
# 
#       The default value is 10 and the maximum allowed value is 100 
# 
#       The start parameter, along with the num parameter can be used to paginate the search results. 
# 
#       Note that the actual number of returned results may be less than num. This happens when the number of results remaining after start is less than num. 
# 
#       Example: num=50 (return a max of 50 results in the response)
#       sortField  Description: Field to sort by. You can also sort by multiple fields for an item, comma separated.
#       The allowed sort field names are title, created, type, owner, avgRating, numRatings, numComments and numViews.
      # sortOrder Values: asc | desc

        # q only:
#       id  Id of the item, for example, id: 4e770315ad9049e7950b552aa1e40869 returns the item for that id.
# itemtype  Item type is either URL, Text, or File. See Item Types for a listing of the different types. This field is pre-defined. For example, itemtype:file return items of the type file.
# owner  Owner of the item, for example, owner:esri returns all content published by Esri.
# created  Created is the date created, for example created: [0000001249084800000 TO 0000001249548000000] finds all items published between August 1, 2009, 12:00AM to August 6, 2009 08:40AM.
# title  Item title, for example, title:"Southern California" returns items with Southern California in the title.
# type  Type returns the type of item and is a pre-defined field. See Item Types for a listing of the different types. For example, type:map returns items with map as the type, such as map documents and map services.
# typekeywords  Type keywords, for example, typekeywords:tool returns items with the tool type keyword such as Network Analysis or Geoprocessing services. See Item Types for a listing of the different types.
# description  Item description, for example, description:California finds all items with the term California in the description.
# tags  The tag field, for example, tags:"San Francisco" returns items tagged with the term San Francisco.
# snippet  Snippet or summary of the item, for example, snippet:"natural resources" returns items with natural resources in the snippet.
# extent  The bounding rectangle of the item. For example, extent: [-114.3458, 21.7518] - [-73.125, 44.0658] returns items within that extent.
# spatialreference  Spatial reference, for example, spatialreference:102100 returns items in the Web Mercator Auxiliary Sphere projection.
# accessinformaton  Accessinformaton, for example, accessinformation:esri returns items with esri as the source credit.
# access  The access field, for example, access:public returns public items. This field is pre-defined and the options are public, private or shared. You will only see private or shared items that you have access to.
# group  The id of the group, for example, group:1652a410f59c4d8f98fb87b25e0a2669 returns items within the given group.
# numratings  Number of Ratings, for example, numratings:6 returns items with six ratings.
# numcomments  Number of comments, for example, numcomments:[1 TO 3] returns items that have one to three comments.
# avgrating  Average rating, for example, avgrating:3.5 returns items with 3.5 as the average rating.
# culture  Culture, for example, culture:en-US, returns the locale of the item. The search engine treats the two parts of the culture code as two different terms and searches for individual languages can be done. For example, culture:en returns all records that have an 'en' in their culture code. There may be overlaps between the codes used for language and the codes used for country, for instance fr-FR, but if the client needs to target a code with this problem they can pass in the complete code.
      SEARCH_OPTIONS = %w{q bbox start num sortField sortOrder}
      SEARCH_FIELDS = %w{id itemtype owner created title type typekeywords description tags snippet extent spatialreference accessinformation access group numratings numcomments avgrating culture}
      def search(options)
        options = options.inject({}) {|hash,(k,v)| hash[k.to_s] = v; hash}
        options['q'] = (SEARCH_FIELDS.collect {|s| "#{s}:#{'"'+options.delete(s)+'"'}" if options.keys.include?(s) } + [options['q']]).compact.join(" AND ")
        # results["results"] = results["results"].collect { |r| Arcgis::Sharing::Item.new(r) }
        get("/search",options)
      end
    end
  end
end
