describe Arcgis::Portal do
  context "accessing portal" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @username = ArcConfig.config["online"]["username"]
      @online.login(:username => @username, :password => ArcConfig.config["online"]["password"])
      @response = @online.organization
    end
    
    it "should be successful" do
      expect(@response.nil?).to eq(false)
    end
    it "should have a name" do
      expect(@response['name'].length > 0).to eq(true)
    end
    it "should have the user" do
      expect(@response['user']['username']).to eq(@username)
    end    
  end
end    