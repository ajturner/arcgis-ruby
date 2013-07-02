require File.dirname(__FILE__)  + '/../arcgis/base'
require File.dirname(__FILE__)  + '/../arcgis/sharing/community'
require File.dirname(__FILE__)  + '/../arcgis/sharing/item'
require File.dirname(__FILE__)  + '/../arcgis/sharing/search'
require File.dirname(__FILE__)  + '/../arcgis/sharing/user'
require File.dirname(__FILE__)  + '/../arcgis/sharing/group'
require File.dirname(__FILE__)  + '/../arcgis/sharing/features'
require File.dirname(__FILE__)  + '/../arcgis/sharing/comment'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'date'
module Arcgis
  class Online
    include Arcgis::Base
    include Arcgis::Sharing::Community
    include Arcgis::Sharing::Item
    include Arcgis::Sharing::Search
    include Arcgis::Sharing::User
    include Arcgis::Sharing::Group
    include Arcgis::Sharing::Features
    include Arcgis::Sharing::Comment
    include Arcgis::Configurable

    class ErrorResponse < RuntimeError
      attr_accessor :response
      def initialize(response={})
        message = response["message"] || response[:message] || response[:code] || response.inspect
        message += response["details"].join("\n") if response["details"]
        super(message)
        @response = response
      end
    end

    
    def initialize(options={})
      update_configuration(options)
    end

    # The root path or url in the service
    def root_url
      "" #host included in #get and #post
    end

    def client
      @client = Arcgis::Client.new(options) unless defined?(@client) && @client.hash == options.hash        
      @client
    end
           
    attr_accessor :token, :token_expires
    # username, password, referrer
    def login(options={})
      update_configuration(options)
      @token = nil if (@token_expires && @token_expires < DateTime.now)
      if(@token.nil?)
        user = post("/generateToken", {:secure => true, :username => @username, :password => @password,
                               :referer => "http://arcgis.com"}.merge(options))
        @token = user["token"]
        @token_expires = DateTime.strptime((user["expires"]/1000).to_s, "%s")
      end
    end
    def logout
      @token = nil
      @token_expires = nil
    end
    
    def get(path,options={})
      path.gsub!(/%username%/,@username || "")
      # puts "Online#get #{path}" if @debug
      uri = URI.parse(@host + path)
      uri.query = URI.encode_www_form({:f => "json",
                             :token => @token}.merge(options))
                             
      return handle_response(Net::HTTP.get_response(uri))
    end

    def post(path, options={})
      secure = options.delete(:secure) || false
      path.gsub!(/%username%/,@username || "")
      # puts "Online#post #{path}" if @debug
      uri = URI.parse(@host + path)
      http = Net::HTTP.new(uri.host, secure ? 443 : uri.port)
      if(secure)
        http.use_ssl = true
        # http.ssl_version = :SSLv3
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.request_uri)
      params = {:f => "json", :token => @token}.merge(options)
      request.set_multipart_form_data(params)
      
      return handle_response(http.request(request))
    end

    private
    # TODO: Add defaults for this? - ajturner
    def update_configuration(options={})
      Arcgis::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key]) if options.include?(key)
      end
    end

    def handle_response(res) 
      if res.is_a?(Net::HTTPSuccess)
        response = JSON.parse(res.body)
        raise ErrorResponse.new(response["error"]) if response["error"]
        return response
      else
        throw res.status
      end
    end
  end
end
