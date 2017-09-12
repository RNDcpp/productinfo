require 'rails_helper'
require 'json'
describe "ProductsAPI",type: :request do
  before do
    @headers = {
      'Accept' => 'application/json',
      'CONTENT_TYPE' => 'application/json'
    }
  end
  context 'GET and Create products' do
    before do
      @product=create(:product_hoge_hoge_100)
    end
    it "GET /products/#id.json" do
      get "/products/#{@product.id}.json",headers:@headers
      expect(response.content_type).to eq("application/json")
      expect(response.status).to eq(200)
      json=JSON.parse(response.body)
      puts(json)
      expect(json["id"]).to eq(@product.id)
      expect(json["cost"]).to eq(@product.cost)
      expect(json["text"]).to eq(@product.text)
    end
    it "POST /products.json" do
      new_product=build(:product_hoge_fuga_100)
      data={:product=>{:name => new_product.name}}.to_json
      puts @headers
      puts data
      post "/products.json",params:data,headers:@headers
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
    end
    it "is invalid without a name" do
      new_product=build(:product_hoge_fuga_100)
      data={:product=>{:cost => new_product.cost}}.to_json
      puts @headers
      puts data
      post "/products.json",params:data,headers:@headers
      expect(response.status).to eq(422)
      expect(response.content_type).to eq("application/json")
      json=JSON.parse(response.body)
      expect(json['name']).to include("can't be blank")

    end
    it "is invalid with a name which is longer than 100 letters"
    it "is valid with a name which has 100 letters"
  end
  context 'Search products' do
    before(:each) do
      @headers = {
        'Accept' => 'application/json',
        'CONTENT_TYPE' => 'application/json'
      }
      create(:product_hoge_hoge)
      create(:product_hoge_hoge_100)
      create(:product_hoge_hoge_1000)
      create(:product_hoge_hoge_10000)
      create(:product_hoge_fuga)
      create(:product_hoge_fuga_100)
      create(:product_hoge_fuga_1000)
      create(:product_hoge_fuga_10000)
      create(:product_fuga_fuga)
      create(:product_fuga_fuga_100)
      create(:product_fuga_fuga_1000)
      create(:product_fuga_fuga_10000)
    end
    it "return the collect number of products with all" do
      get '/products.json',headers:@headers
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json = JSON.parse(response.body)
      expect(json.size).to eq(12)
    end
    it "return collect products list with name search" do
      data={q:'fuga',search_target:"name"}
      get '/products/search.json',params:data,headers:@headers
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json = JSON.parse(response.body)
      puts json
      expect(json.size).to eq(4)
    end
    it "return collect products list with name search and max_cost" do
      data={q:'fuga',max_cost:1000,search_target:"name"}
      get '/products/search.json',params:data,headers:@headers
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      json = JSON.parse(response.body)
      puts json
      expect(json.size).to eq(2)
    end
  it "return collect products list with name search and min_cost"
  it "return collect products list with name search and min_cost and max_cost"
  it "return collect products list with name_and_text search"
  it "return collect products list with name_and_text search and max_cost"
  it "return collect products list with name_and_text search and min_cost"
  it "return collect products list with name_and_text search and min_cost and max_cost"
  it "return collect products list with empty name search, with max_cost"
  it "return collect products list with empty name search, with min_cost"
  it "return collect products list with empty name search, with min_cost and max_cost"
  it "return collect products list with empty name_and_text search, with min_cost"
  it "return collect products list with empty name_and_text search, with max_cost"
  it "return collect products list with empty name_and_text search, with min_cost and max_cost"
  end
end
