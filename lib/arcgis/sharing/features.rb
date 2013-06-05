module Arcgis
  module Sharing
    module Features
      include Arcgis::Base
      # API Docs: http://devext.arcgis.com/apidocs/rest/features.html
      def features_url
        "features/"
      end
      
      FEATURES_METHODS = {
        :content => {
          :post => ["analyze", "generate"]
        }
      }
      
      extend_api(self.name.split("::").last.downcase,FEATURES_METHODS)
    end
  end
end
