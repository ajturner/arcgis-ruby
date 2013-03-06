module Arcgis
  module Base
    def self.included(base)
      base.extend ClassMethods
    end
      
    module ClassMethods
      # Factory for building API endpoints from Definitions
      def extend_api(api,definition)
        definition.each do |parent,ops|
          ops.each do |op,methods|
            methods.each do |method|
              # build the method, but allow for 'root' level methods without a name (e.g. /community/users)
              define_method("#{api}_#{method}".gsub(/_$/,'')) { |options| 
                # differentiate 'items' for /content/ from '' for /community/ - e.g. content/users/id vs. community/users/id
                url = "#{self.send(parent.to_s+'_url')}#{self.send(api.to_s+'_url')}#{options.delete(:id)}/#{method.gsub(/items/,'')}"
                url.gsub!(/community\/community/,'community')
                self.send(op,url,options) 
              }
            end
          end
        end
      end
    end    
  end
end