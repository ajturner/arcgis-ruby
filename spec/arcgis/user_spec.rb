require 'helper'

describe Arcgis::Sharing::User do
  context "search for users" do 
    before :all do 
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "by username" do 
      before :all do
        @users = @online.community_users(:q => "ajturner")
      end
      it "should have search parameters" do
        expect(@users["query"]).to eq("ajturner")
        expect(@users["total"]).to eq(1)
        expect(@users["start"]).to eq(1)
        expect(@users["num"]).to eq(10)
        expect(@users["nextStart"]).to eq(-1)
      end
      it "should return results" do
        expect(@users["results"].length>0).to eq(true)
      end
      it "should have valid results" do
        expect(@users["results"][0]["username"]).to eq("ajturner")
      end
    end
  end
  context "for a user" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "logging in" do
      before :all do 
        @online.login(:username => ArcConfig.config["online"]["username"],
          :password => ArcConfig.config["online"]["password"])
        @token = @online.token
      end
      it "should have a token" do
        expect(@token.nil?).to eq(false)
      end
      it "should have a future token expiration" do
        expect(@online.token_expires.nil?).to eq(false)
        expect(@online.token_expires > DateTime.now).to eq(true)
      end
      describe "logging in before token is expired" do
        before :all do
          @online.login(:username => ArcConfig.config["online"]["username"],
            :password => ArcConfig.config["online"]["password"])
        end
        it "should not refresh token" do
          expect(@online.token).to eq(@token)
        end
      end
      describe "logging in after token is expired" do
        before :all do
          @online.token_expires = DateTime.now - 1 #year
          @online.login(:username => ArcConfig.config["online"]["username"],
          :password => ArcConfig.config["online"]["password"])          
        end
        it "should get a new token" do
          expect(@online.token != @token).to eq(true)
        end
      end
      after :all do
        @online.logout
      end
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
        expect(@items["items"].length >= 0).to eq(true)
      end
    end
  end
end
