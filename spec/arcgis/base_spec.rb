require 'helper'

class APIDouble
  # Given get and post methods and some expected url parts
  %w(get post).each do |method|
    define_method(method.to_sym) do |path, options|
      @path = path
      @options = options
    end
  end
  def community_url
    "/community/"
  end
  def content_url
    "/content/"
  end
  def apiDouble_url
    "/apiDouble/"
  end
  attr_reader :path, :options

  # When we declare a part of the AGOL/Portal API
  include Arcgis::Base
  extend_api("apiDouble", { community: {
                              post: [ 'apiMethod' ], get: ["", "anotherMethod", "sameNameMethod"] },
                            content: {
                              post: [ 'contentMethod'], get: ["", "anotherContentMethod"]} } )
end

describe Arcgis::Base do
  before :each do 
    @api = APIDouble.new
  end

  context 'extend api creates methods' do
    it 'from post operation' do
      expect(@api.respond_to?('apiDouble_apiMethod')).to be true
    end
    it 'on the api community root' do
      expect(@api.respond_to?('apiDouble_community')).to be true
    end
    it 'on the api content root' do
      expect(@api.respond_to?('apiDouble_content')).to be true
    end
    it 'from get operation' do
      expect(@api.respond_to?('apiDouble_anotherMethod')).to be true
    end
    it 'for a content post operation' do 
      expect(@api.respond_to?('apiDouble_contentMethod')).to be true
    end
    it 'for a content get opertaion' do 
      expect(@api.respond_to?('apiDouble_anotherContentMethod')).to be true
    end
  end

  context 'calling created methods' do
    it 'should generate an api operation path' do
      @api.apiDouble_apiMethod({})
      expect(@api.path).to eq("/community/apiDouble/apiMethod")
    end

    it 'should generate an api root path' do
      @api.apiDouble_community({})
      expect(@api.path).to eq("/community/apiDouble/")
    end

    it 'should generate a content item operation path' do
      @api.apiDouble_contentMethod(id: 'item_id')
      expect(@api.path).to eq("/content/apiDouble/item_id/contentMethod")
    end
  end
end
