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
              # build the method, but allow for 'root' level methods with the parent 
              # (e.g. /community/user = user_community; /community/user/update = user_update)
              subapi = method.length == 0 ? parent.to_s : method
              define_method("#{api}_#{subapi}".gsub(/_$/,'')) { |options| 
                # differentiate 'items' for /content/ from '' for /community/ - e.g. content/users/id vs. community/users/id
                url = "#{self.send(parent.to_s+'_url')}#{self.send(api.to_s+'_url')}#{options.delete(:id)}/#{method.gsub(/items/,'')}"
                url.gsub!(/\/+/, '/')
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
