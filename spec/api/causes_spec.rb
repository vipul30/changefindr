require 'spec_helper'
require 'socket'


describe Changefindrapi::API do
  describe "GET /api/causes/get_causes" do
    it "Get all Causes" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      
      get 'http://127.0.0.1:3000/api/causes/get_causes?api_key=sdklujweoiuroei8'
      #put response
      
      response.code.should be(200)
    end
  end
end

