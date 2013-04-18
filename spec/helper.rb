require 'arcgis'
require 'rspec'
require 'rspec/expectations'
require 'yaml'
module Helpers
  def create_testing_group(options={})
    @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    @username = ArcConfig.config["online"]["username"]
    @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
    @group = @online.community_createGroup(:title => "Ruby Testing Group",
                                           :description => "Group for Testing",
                                           :access => "org",
                                           :tags => "test,ruby")
  end

  def delete_testing_group
    @online.group_delete(:id => @group["group"]["id"]) unless @group.nil? || @group["group"].nil?
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include Helpers
end

module ArcConfig
  class << self
    def config
      @config ||= YAML.load_file(File.dirname(__FILE__) + '/../config.yml')
    end
  end
end
