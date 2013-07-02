
describe Arcgis::Sharing::Features do
  context "analyzing features" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
      @analysis = @online.features_analyze(:type => "CSV", :text => %Q{State,Pop\nVA,50\nPA,100})
    end
    it "should have records" do
      expect(@analysis["records"].length).to eq(2)
    end
    it "should have location type" do
      expect(@analysis["publishParameters"]["locationType"]).to eq("address")
    end
    
  end
end
