describe Arcgis::Sharing::Comment do
  context "adding an comment" do
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @username = ArcConfig.config["online"]["username"]
      @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
      response = @online.item_add(:url   => "http://www.mymappingapplication.com",
                       :title => "My Mapping Application",
                       :type  => "Web Mapping Application",
                       :tags  => %w{web mapping application}.join(","))
      @item = @online.item(:id => response['id'])
    end

    describe "with simple text" do
      before :all do
        @response = @online.item_addComment(:id => @item['id'], :comment => 'Testing Comment')
        @comment = @online.comment(:item => @item['id'], :id => @response['commentId'])
      end
      it "should be a comment" do
        expect(@comment["id"]).to eq(@response['commentId'])
      end
    end
    after :all do
      response = @online.item_delete(:items => [@item["id"]])
      expect(response["results"].first["success"]).to eq(true)
    end
  end
end
