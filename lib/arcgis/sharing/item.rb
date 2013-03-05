require File.dirname(__FILE__) + '/../online'
module Arcgis
  module Sharing
    # API Docs: http://www.arcgis.com/apidocs/rest/item.html
    module Item
      # Methods:
      # <item-url> GET comments rating relatedItems
      # <item-url> POST addComment addRating deleteRating
      
      # http://www.arcgis.com/sharing/rest/content/items/{id}?f=json
      # def initialize(options)
      #   options.each do |k,v|
      #     self[k] = v
      #   end
      # end
      
      def item(options)
        item = get("/content/items/#{options[:id]}")
        # return Item.new(item)
      end
      
      # Register a new item in ArcGIS Online
      # 
      # username is optional. If included it will be added to that user. 
      #  Otherwise it will use the username of the login credentials
      def add_item(options={})
        username = options.delete(:username) || "%username%"
        post("/content/users/#{username}/addItem",options)
      end
      
      # Delete an item from ArcGIS Online
      # 
      # options
      #   items array of item id's
      # Returns {"error"=>{"code"=>400, "messageCode"=>"CONT_0001", "message"=>"Item '8960a63b2f1443f9a0a07922fc4bffec' does not exist or is inaccessible.", "details"=>[]}}
      def delete_items(options={})
        username = options.delete(:username) || "%username%"
        post("/content/users/#{username}/deleteItems",{:items => options[:items].join(",")})
      end
      
      def update_item(options={})
        id = options.delete(:id)
        item = get("/content/items/#{id}")
        item = post("/content/users/#{item["owner"]}/items/#{item["id"]}/update",options)
      end
      
      # 
      # http://www.arcgis.com/apidocs/rest/publishitem.html
      # 
      # itemId
      # filetype serviceDefinition | shapefile | csv | Tile Package | Feature Service
      # publishParameters
      # outputType
      # 
      # name (required)
      def publish_item(options={})
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
      def analyze_item(options={})
        options[:itemId] = options.delete(:id) unless options.include?(:itemId)
        post("/content/features/analyze",options)
      end
    end
  end
end
