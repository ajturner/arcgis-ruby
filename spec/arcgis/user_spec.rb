require 'helper'

describe Arcgis::Sharing::User do
  context "working with an user" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "by loading" do
      before :all do 
        @user = @online.user(:user => ArcConfig.config["online"]["username"])
      end
      it "should be a user"
    end
  end
end
