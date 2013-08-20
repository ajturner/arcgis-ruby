require 'helper'
describe Arcgis::Sharing::User do
  context "As a user" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @username = ArcConfig.config["online"]["username"]
      @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
    end
    describe "creating a folder" do
      before :all do
        @response = @online.user_createFolder(:title => "My New Folder + #{Time.now}")
        @id = @response["folder"]['id']
      end
      it "should be successful" do
        expect(@response["success"]).to be_true
      end
      it "should have the title" do
        expect(@response["folder"]["title"]).to match("My New Folder")
      end
      after :all do
        @online.user_deleteFolder(:id => @id)
      end
    end
  end
end
