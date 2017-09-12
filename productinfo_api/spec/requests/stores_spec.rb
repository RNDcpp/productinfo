require 'rails_helper'

RSpec.describe "Stores", type: :request do
  before do
    @headers={
      'Accept'=>'application/json',
      'Content-Type'=>'application/json'
    }
  end
  describe "GET /stores" do
    it "works!" do
      get stores_path,headers:@headers
      expect(response).to have_http_status(200)
    end
  end
  context "GET /stores/#id/products" do
    before do
      @store=create(:store)
      @product1=create(:product_hoge_hoge_100)
      StoreProductRelation.create(store:@store,product:@product1,stock:12)
      @product2=create(:product_hoge_hoge_1000)
      StoreProductRelation.create(store:@store,product:@product2,stock:20)
      @product3=create(:product_hoge_fuga_100)
    end
    it "works!" do
      puts(store_products_path(id:@store.id))
      get store_products_path(id:@store.id),headers:@headers
      puts(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      json=JSON.parse(response.body)
      puts(json)
      expect(json.size).to eq(2)
      expect(json.any?{|e| e['id']==@product1.id}).to be_truthy
      expect(json.any?{|e| e['id']==@product2.id}).to be_truthy
      expect(json.all?{|e| e['id']!=@product3.id}).to be_truthy
      product1_stock=json.select{|e| e['id']==@product1.id}[0]['stock']
      expect(product1_stock).to eq(12)
    end
  end
  context "GET /stores/search" do
    before do
      @store=create(:store)
      @hoge1=create(:store_hoge)
      @hoge2=create(:store_hoge)
      @fuga=create(:store_fuga)
    end
    it "works!" do
      puts(stores_search_path)
      get stores_search_path,params:{q:'hoge'},headers:@headers
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      json=JSON.parse(response.body)
      puts(json)
      expect(json.size).to eq(2)
      expect(json.any?{|e| e['id']==@hoge1.id}).to be_truthy
      expect(json.any?{|e| e['id']==@hoge2.id}).to be_truthy
      expect(json.all?{|e| e['id']!=@fuga.id}).to be_truthy
    end
  end
  context "POST /stores/#id/products" do
    before do
      @store=create(:store)
      @product=create(:product_hoge_hoge_1000)
    end
    it "works!" do
      puts(store_products_path(id:@store.id))
      post store_products_path(id:@store.id),params:{product_id:@product.id,stock:12}.to_json,headers:@headers
      puts(response.body)
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json')
    end
  end
end
