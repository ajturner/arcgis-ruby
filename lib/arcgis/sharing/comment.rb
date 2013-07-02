module Arcgis
  module Sharing
    module Comment
      include Arcgis::Base
      # API Docs: http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#/Item_Comments/02r300000088000000/
      def comment_url
        "comments/"
      end
      
      # TODO is this better as a const or a method? - ajturner
      GROUP_METHODS = {
        :content => {
          :get => [""],
          :post => ["update","delete"]
        },
        :community => {}
      }
      
      extend_api(self.name.split("::").last.downcase,GROUP_METHODS)
      
      # Helper function for finding a group
      def comment(options)
        get("/content/items/#{options.delete(:item)}/comments/#{options[:id]}",options)
      end

      def comment_update(options)
        post("/content/items/#{options.delete(:item)}/comments/#{options[:id]}/update",options)
      end
            
      def comment_delete(options)
        post("/content/items/#{options.delete(:item)}/comments/#{options[:id]}/delete",options)
      end
      
    end
  end
end
