module Arcgis
  module Sharing
    module Group
      include Arcgis::Base
      # API Docs: http://www.arcgis.com/apidocs/rest/group.html
      def group_url
        "groups/"
      end
      
      # TODO is this better as a const or a method? - ajturner
      GROUP_METHODS = {
        :content => {
          :get => ["items"]
        },
        :community => {
          :post => %w{update reassign delete join invite leave removeUsers },
          :get => ["", "users", "applications"]
        }
      }
      
      extend_api(self.name.split("::").last.downcase,GROUP_METHODS)
    end
  end
end
