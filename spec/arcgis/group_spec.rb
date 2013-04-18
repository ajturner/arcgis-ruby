require 'helper'
# GROUP_METHODS = {
#   :post => %w{update reassign delete join invite leave removeUsers },
#   :get => %w{users applications}
# }
describe Arcgis::Sharing::Group do
  context "searching for groups" do 
    before :all do 
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "by group name" do 
      before :all do
        @query = "ArcGIS for Local Government"
        @groups = @online.community_groups(:q => @query)
      end
      it "should have search parameters" do
        expect(@groups["query"]).to eq(@query)
        expect(@groups["start"]).to eq(1)
        expect(@groups["num"]).to eq(10)
        expect(@groups["nextStart"]).to eq(11)
      end
      it "should return results" do
        expect(@groups["results"].length>0).to eq(true)
      end
    end
  end  
  describe "creating a group" do
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @username = ArcConfig.config["online"]["username"]
      @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
      @group = @online.community_createGroup(:title => "Ruby Testing Group", 
                                             :description => "Group for Testing",
                                             :access => "private",
                                             :tags => "test,ruby")
    end
    it "should create the group" do
      expect(@group["success"]).to eq(true)
    end
    it "should have an id" do
      expect(@group["group"]["id"].nil?).to eq(false)
    end
    it "should have a title" do
      expect(@group["group"]["title"]).to eq("Ruby Testing Group")
    end
    it "should have an owner" do
      expect(@group["group"]["owner"]).to eq(@username)
    end
    it "should have a description" do
      expect(@group["group"]["description"]).to eq("Group for Testing")
    end
    it "should not be isInvitationOnly" do
      expect(@group["group"]["isInvitationOnly"]).to eq(false)
    end
    it "should not have tags" do
      expect(@group["group"]["tags"]).to eq(["test", "ruby"])
    end
    it "should be private" do
      expect(@group["group"]["access"]).to eq("private")      
    end    
    after :all do
      @online.group_delete(:id => @group["group"]["id"]) unless @group.nil? || @group["group"].nil?
    end
    
  end
  
  describe "searching for a group" do 
    before :all do 
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @results = @online.group(:q => "R&D")
    end
    it "should have results" do 
      expect(@results.length>0).to eq(true)
    end
  end
  context "for a group" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @user = @online.user(:user => ArcConfig.config["online"]["username"])
      @group_id = "6994b7fc94fd4fca944348303191aad5"
    end
    describe "get their applications" do
      before :all do
        @applications = @online.group_applications(:id => @group_id)
      end
      it "should have the active applications"
    end
    describe "get their users" do
      before :all do
        @group = @online.group_users(:id => @group_id)
      end
      it "should have an owner" do
        expect(@group["owner"]).to eq("olearydw_dcdev")
      end
      it "should have admins" do
        expect(@group["admins"]).to eq(["olearydw_dcdev"])
      end
      it "should have the users" do
        expect(@group["users"]).to eq([])
      end
    end
    describe "get their content" do
      before :all do
        @items = @online.group_items(:id => @group_id)
      end
      it "should have the active applications" 
    end    
  end
end
