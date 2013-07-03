module Arcgis
  module Sharing
    # API Docs: http://www.arcgis.com/apidocs/rest/item.html
    module Item
      MAX_SERVICENAME_LIMIT = 80 
      
      include Arcgis::Base
      def item_url
        "items/"
      end
      
      # Methods:
      # <item-url> GET comments rating relatedItems
      # <item-url> POST addComment addRating deleteRating
      ITEM_METHODS = {
        :content => {
          :get => ["", "comments", "rating", "relatedItems", "data","groups"],
          :post => %w{addRelationship deleteRelationship addItem addComment addRating deleteRating share unshare}
        }
      }
      
      extend_api(self.name.split("::").last.downcase,ITEM_METHODS)

      # Helper function for loading an item
      def item(options)
        item_content(options)
      end
      
      # http://www.arcgis.com/sharing/rest/content/items/{id}?f=json
      # def initialize(options)
      #   options.each do |k,v|
      #     self[k] = v
      #   end
      # end
      
      # def item(options)
      #   item = get("/content/items/#{options[:id]}")
      #   # return Item.new(item)
      # end
      # 
      # def item_groups(options={})
      #   get("/content/items/#{item["id"]}/groups",)
      # end
      # # http://www.arcgis.com/apidocs/rest/itemshareitem.html
 #      # options
 #      #   everyone <boolean>
 #      #   org <boolean>
 #      #   groups <array>
 #      def item_share(options={})
 #        options[:groups] = options.delete(:groups).join(",") if options.include?(:groups) && options.is_a?(Array)
 #        post("/content/items/#{item["id"]}/share",options)
 #      end
 #      
 #      # http://www.arcgis.com/apidocs/rest/itemunshareitem.html
 #      def item_unshare(options={})
 #        options[:groups] = options.delete(:groups).join(",") if options.include?(:groups) && options.is_a?(Array)
 #        post("/content/items/#{item["id"]}/unshare",options)
 #      end
 
 
       # 
       # USER CONTENT
       # 
       
      # Register a new item in ArcGIS Online
      # 
      # username is optional. If included it will be added to that user. 
      #  Otherwise it will use the username of the login credentials
      def item_add(options={})
        username = options.delete(:username) || "%username%"
        options[:file] = File.open(options.delete[:file]) if options.include?(:file) && options[:file].is_a?(String)
        post("/content/users/#{username}/addItem",options)
      end
      
      # Delete an item from ArcGIS Online
      # 
      # options
      #   items array of item id's
      # Returns {"error"=>{"code"=>400, "messageCode"=>"CONT_0001", "message"=>"Item '8960a63b2f1443f9a0a07922fc4bffec' does not exist or is inaccessible.", "details"=>[]}}
      def item_delete(options={})
        username = options.delete(:username) || "%username%"
        post("/content/users/#{username}/deleteItems",{:items => options[:items].join(",")})
      end
      

            
      def item_update(options={})
        id = options.delete(:id)
        item = get("/content/items/#{id}")
        item = post("/content/users/#{item["owner"]}/items/#{item["id"]}/update",options)
      end
      
      # http://www.arcgis.com/apidocs/rest/itemunshareitem.html
      # 
      # itemId
      # filetype serviceDefinition | shapefile | csv | Tile Package | Feature Service
      # publishParameters
      # outputType
      # 
      # name (required)
      def item_publish(options={})
        options[:itemId] = options.delete(:id) unless options.include?(:itemId)
        post("/content/users/#{username}/publish",options)
      end
      
      # Analyze returns information about an item including the fields present as well as sample records.
      # http://www.arcgis.com/apidocs/rest/analyze.html
      # 
      # id - id of the item
      # type shapefile | csv
      # file
      # text
      # 
      def item_analyze(options={})
        options[:itemId] = options.delete(:id) unless options.include?(:itemId)
        response = post("/content/features/analyze",options)
        response["publishParameters"]["name"] = response["publishParameters"]["name"][0..MAX_SERVICENAME_LIMIT] if response["publishParameters"]["name"].length > MAX_SERVICENAME_LIMIT
        response
      end
    end
  end
end
