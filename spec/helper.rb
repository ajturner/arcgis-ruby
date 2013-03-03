require 'arcgis'
require 'rspec'
require 'rspec/expectations'
require 'yaml'
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module ArcConfig
  class << self
    def config
      @config ||= YAML.load_file(File.dirname(__FILE__) + '/../config.yml')
    end
  end
end
