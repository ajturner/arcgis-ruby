require 'helper'

describe Arcgis::Sharing::Search do
  include ArcConfig
  context "performing a search" do 
    before :all do
      @online = Arcgis::Online.new(:host => ArcConfig.config["online"]["host"])
    end
    describe "by keyword and typekeywords" do
      before :all do 
        @results = @online.search(:q => "stuff", :typekeywords => "Data")
      end
      it "should fetch @results" do
        expect(@results["results"].length).to eq(@results["num"])
      end
      it "should return the query" do
        expect(@results["query"]).to eq("stuff AND typekeywords:'Data'")
      end
      it "should have pagination" do
        # expect(@results["total"]).to gt(1)
        expect(@results["start"]).to eq(1)
        expect(@results["num"]).to eq(10)
        expect(@results["nextStart"]).to eq(11)
      end
      it "should return an ArcGIS Item"
    end
  end
end
