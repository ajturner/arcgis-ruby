require 'helper'
# GROUP_METHODS = {
#   :post => %w{update reassign delete join invite leave removeUsers },
#   :get => %w{users applications}
# }
describe Arcgis::Sharing::Group do
  describe "creating a group" do
    before :all do
      create_testing_group
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
      expect(@group["group"]["access"]).to eq("org")
    end
    after :all do
      delete_testing_group
    end
  end

  describe "searching for a group" do
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @results = @online.group(:q => "R&D")
    end
    it "should have results" do
      expect(@results["results"].length).to eq(@results["total"])
    end
  end
  context "for a group" do
    before :all do
      create_testing_group
      @user = @online.user(:id => ArcConfig.config["online"]["username"])
      @group_id = @group["group"]["id"]
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
        expect(@group["owner"]).to eq(@user["username"])
      end
      it "should have admins" do
        expect(@group["admins"]).to eq([@user["username"]])
      end
      it "should have the users" do
        expect(@group["users"]).to eq([])
      end
    end
    describe "get their content" do
      before :all do
        @items = @online.group_items(:id => @group_id)
      end
      it "should have items"
    end
    after :all do
      delete_testing_group
    end
  end
end
