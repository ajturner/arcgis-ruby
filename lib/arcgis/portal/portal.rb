module Arcgis
  module Portal
    # API Docs: http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#/Portal_Self/02r3000001m7000000/
    # http://dcdev.maps.arcgis.com/sharing/rest/portals/self
    include Arcgis::Base
    def portal_url
      "portals/"
    end
    
    def organization(options = {})
      get("#{portal_url}/self",options)
    end
  end
end
