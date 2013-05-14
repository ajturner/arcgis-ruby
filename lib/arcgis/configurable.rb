module Arcgis
  module Configurable
    attr_accessor :host, :username, :password, :token, :debug
    class << self
      # TODO: include defaults? - ajturner
      def keys
        @keys ||= [
          :host,
          :username,
          :password,
          :token,
          :debug
        ]
      end
    end

    def configure
      yield self
      self
    end
  end
end
