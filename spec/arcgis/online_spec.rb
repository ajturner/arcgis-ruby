require 'helper'

describe Arcgis::Online do
  context "working with online" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "logging in" do
      before :all do 
        @online.login(:username => ArcConfig.config["online"]["username"],
                      :password => ArcConfig.config["online"]["password"])
      end
      it "should work" do
       expect(@online.token.length>0).to eq(true)
      end
    end
  end
end
