require 'helper'

describe Arcgis::Sharing::User do
  context "for a user" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "get their profile" do
      before :all do 
        @user = @online.user(:user => ArcConfig.config["online"]["username"])
      end
      it "should have a username" do
        expect(@user["username"]).to eq(ArcConfig.config["online"]["username"])
      end
    end
    describe "load their items" do
      before :all do
        @username = ArcConfig.config["online"]["username"]
        @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
        @items = @online.user_items(:user => @username)
      end
      it "should have items" do
        expect(@items["items"].length > 0).to eq(true)
      end
    end
    
  end
end
