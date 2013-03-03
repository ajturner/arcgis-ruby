module Arcgis
  module Sharing
    # API Docs: http://www.arcgis.com/apidocs/rest/user.html
    module User
      def user(options)
        item = get("/community/users/#{options[:user]}")
        return item
      end
    end
  end
end
