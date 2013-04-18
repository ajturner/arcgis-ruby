
describe Arcgis::Sharing::Item do
  context "adding an item" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @username = ArcConfig.config["online"]["username"]
      @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
    end
    describe "by URL" do
      before :all do
        @response = @online.item_add(:url   => "http://www.mymappingapplication.com",
                         :title => "My Mapping Application",
                         :type  => "Web Mapping Application",
                         :tags  => %w{web mapping application}.join(","))
        @id = @response["id"]        
        @item = @online.item(:id => @id)
      end
      it "should be an item" do
        expect(@item["id"]).to eq(@id)
      end
      it "should have tags" do
        expect(@item["tags"]).to eq(%w{web mapping application})
      end
      it "should have title" do
        expect(@item["title"]).to eq("My Mapping Application")
      end
      it "should have type" do
        expect(@item["type"]).to eq("Web Mapping Application")
      end
      it "should have url" do
        expect(@item["url"]).to eq("http://www.mymappingapplication.com")
      end
      it "should have description" do
        expect(@item["description"]).to eq(nil)
      end
      it "should have blank rating" do
        expect(@item["avgRating"]).to eq(0)
      end        
      it "should have no ratings" do
        expect(@item["numRatings"]).to eq(0)
      end        
      it "should have no comments" do
        expect(@item["numComments"]).to eq(0)
      end
      it "should have owner" do
        expect(@item["owner"]).to eq(@username)
      end
      describe "editing" do
        before :all do
          @tags = Time.now.to_s
          @online.item_update(:id => @id, :tags => @tags)
          @item = @online.item(:id => @id)
        end
        it "should have updated tags" do
          expect(@item["tags"]).to eq([@tags])          
        end
      end
      after :all do
        response = @online.item_delete(:items => [@item["id"]])
        expect(response["results"].first["success"]).to eq(true)
      end
    end
    describe "deleting an item" do
      before :all do
        @response = @online.item_add(:url   => "http://www.mymappingapplication.com",
                         :title => "My Mapping Application",
                         :type  => "Web Mapping Application",
                         :tags  => %w{web mapping application})
        @delete = @online.item_delete(:items => [@response["id"]])
      end
      it "should be successful" do
        expect(@delete["results"].length).to eq(1)
        expect(@delete["results"].first["success"]).to eq(true)
        expect(@delete["results"].first["itemId"]).to eq(@response["id"])
      end        
      it "should not exist" do
        expect { @online.item(:id => @response["id"]) }.to raise_error { |error|
          expect(error.response["code"]).to eq(400)
          expect(error.response["message"]).to eq("Item '#{@response["id"]}' does not exist or is inaccessible.")          
        }
      end
    end
  end
end
