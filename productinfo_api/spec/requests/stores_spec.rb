require 'rails_helper'

RSpec.describe "Stores", type: :request do
  before do
    @headers={
      'Accept'=>'application/json',
      'Content-Type'=>'application/json'
    }
  end
  describe "GET /stores" do
    it "works! (now write some real specs)" do
      get stores_path,headers:@headers
      expect(response).to have_http_status(200)
    end
  end
end
