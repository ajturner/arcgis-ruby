require 'helper'

describe Arcgis::Sharing::User do
  context "for a user" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "get their profile" do
      before :all do 
        @user = @online.user(:id => ArcConfig.config["online"]["username"])
      end
      it "should have a username" do
        expect(@user["username"]).to eq(ArcConfig.config["online"]["username"])
      end
      it "should have a fullName" do
        expect(@user["fullName"].length > 0).to eq(true)
      end
      it "should have a description" do
        expect(@user["description"].length > 0).to eq(true)
      end
    end
    describe "load their items" do
      before :all do
        @username = ArcConfig.config["online"]["username"]
        @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
        @items = @online.user_items(:id => @username)
      end
      it "should have items" do
        expect(@items["items"].length > 0).to eq(true)
      end
    end
    
  end
end
