module Arcgis
  module Sharing
    module Community
      include Arcgis::Base
      # API Docs: http://www.arcgis.com/apidocs/rest/community.html
      def community_url
        root_url + "community/"
      end
      def content_url
        root_url + "content/"
      end
      
      COMMUNITY_METHODS = {
        :community => {
          :post => ["createGroup"]
        }
      }

      extend_api("community", COMMUNITY_METHODS)

    end
  end
end
