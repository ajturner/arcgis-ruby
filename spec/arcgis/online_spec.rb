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

    describe "failing operation" do
      before :all do 
        @online.login(:username => ArcConfig.config["online"]["username"],
                      :password => ArcConfig.config["online"]["password"])
      end
      it 'should raise a decent message on get' do
        expect { @online.get("/portals?f=json", {}) }.to raise_error(/output format 'json' not supported/)
      end
      it 'should raise a decent message on post' do
        expect { @online.post("/portals?f=json", {}) }.to raise_error(/output format 'json' not supported/)
      end
    end
  end
end
