require 'arcgis/sharing/item'
require 'arcgis/sharing/search'
require 'arcgis/sharing/user'
require 'json'
require 'net/http'
module Arcgis
  class Online
    include Arcgis::Sharing::Item
    include Arcgis::Sharing::Search
    include Arcgis::Sharing::User
    include Arcgis::Configurable
    
    def initialize(options={})
      update_configuration(options)
    end
    
    def client
      @client = Arcgis::Client.new(options) unless defined?(@client) && @client.hash == options.hash        
      @client
    end
      
    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"
     
    # username, password, referrer
    def login(options={})
      update_configuration(options)
      user = post("/generateToken", {:secure => true, :username => @username, :password => @password,
                             :referer => "http://arcgis.com"}.merge(options))
      @token = user["token"]
    end
    
    def get(path,options={})
      path.gsub!(/%username%/,@username || "")
      uri = URI.parse(@host + path)
      uri.query = URI.encode_www_form({:f => "json",
                             :token => @token}.merge(options))

      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        return JSON.parse(res.body)
      else
        throw res.status
      end
      
    end
    def post(path, options={})
      secure = options.delete(:secure) || false
      path.gsub!(/%username%/,@username || "")
      uri = URI.parse(@host + path)
      http = Net::HTTP.new(uri.host, secure ? 443 : uri.port)
      if(secure)
        http.use_ssl = true
        http.ssl_version = :SSLv3
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({:f => "json",
                             :token => @token}.merge(options))

      res = http.request(request)
      if res.is_a?(Net::HTTPSuccess)
        return JSON.parse(res.body)
      else
        throw res.status
      end   
      
    end

               
    private
    # TODO: Add defaults for this? - ajturner
    def update_configuration(options={})
      Arcgis::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key]) if options.include?(key)
      end
    end
    # def method_missing(method_name, *args, &block)
    #   return super unless client.respond_to?(method_name)
    #   client.send(method_name, *args, &block)
    # end
  end
end
