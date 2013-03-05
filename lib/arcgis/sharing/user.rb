module Arcgis
  module Sharing
    # API Docs: http://www.arcgis.com/apidocs/rest/user.html
    module User
      def user(options = {})
        get("/community/users/#{options[:user]}")
      end
      
      # http://www.arcgis.com/apidocs/rest/usercontent.html
      def user_items(options = {})
        url = "/content/users/#{options[:user]}"
        url << "/#{options[:folder]}" if options.include?(:folder)
        get(url)
      end
    end
  end
end
