require 'rails_helper'
describe "Products" do
  it "is valid with a name" do
    product=Product.new(name:'test')
    expect(product).to be_valid
  end
  it "is invalid without a name" do
    product=Product.new(cost: 1000)
    product.valid?
    expect(product.errors[:name]).to include("can't be blank")
  end
  it "is invalid with a name which is longer than 100 letters" do
    product=Product.new(name: Faker::Lorem.characters(101))
    product.valid?
    expect(product.errors[:name]).to include("name is too long")
  end
  it "is valid with a name which has 100 letters" do
    product=Product.new(name: Faker::Lorem.characters(100))
    expect(product).to be_valid
  end
  it "is invalid with a text which is longer than 500 letters" do
    product=Product.new(name: Faker::Lorem.characters(1),text: Faker::Lorem.characters(501))
    product.valid?
    expect(product.errors[:text]).to include("text is too long")
  end
  it "is valid with a name which has 500 letters" do
    product=Product.new(name: Faker::Lorem.characters(1),text: Faker::Lorem.characters(500))
    expect(product).to be_valid
  end
  context 'search test' do 
    before(:each) do
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
      @product=create(:product_fuga_fuga_10000)
      @store=create(:store)
      StoreProductRelation.create(store:@store,product:@product,stock:12)
    end
    it "return /collect products list with store_id" do
      products=Product.search({q:'fuga',search_target: 'name',store_id:@store.id})
      expect(products.count).to eql(1)
    end
    it "return the collect number of products with all" do
      products=Product.all
      expect(products.count).to eql(12)
    end
    it "return collect products list with name search" do
      products=Product.search({q:'fuga',search_target: 'name'})
      expect(products.count).to eql(4)
    end
    it "return collect products list with name search and max_cost" do
      products=Product.search({q:'fuga',max_cost:1000,search_target: 'name'})
      expect(products.count).to eql(2)
    end
    it "return collect products list with name search and min_cost" do
      products=Product.search({q:'fuga',min_cost:1000,search_target: 'name'})
      expect(products.count).to eql(2)
    end
    it "return collect products list with name search and min_cost and max_cost" do 
      products=Product.search({q:'fuga',min_cost:1000,max_cost: 9999,search_target: 'name'})
      expect(products.count).to eql(1)
    end
    it "return collect products list with name_and_text search" do
      products=Product.search({q:'fuga',search_target: 'name_and_text'})
      expect(products.count).to eql(8)
    end
    it "return collect products list with name_and_text search and max_cost" do
      products=Product.search({q:'fuga',max_cost: 1000,search_target: 'name_and_text'})
      expect(products.count).to eql(4)
    end
    it "return collect products list with name_and_text search and min_cost" do
      products=Product.search({q:'fuga',min_cost: 1000,search_target: 'name_and_text'})
      expect(products.count).to eql(4)
    end
    it "return collect products list with name_and_text search and min_cost and max_cost" do
      products=Product.search({q:'fuga',min_cost: 1000,max_cost: 9999,search_target: 'name_and_text'})
      expect(products.count).to eql(2)
    end
    it "return collect products list with empty term search, with max_cost" do
      products=Product.search({max_cost: 1000})
      expect(products.count).to eql(6)
    end
    it "return collect products list with empty term search, with min_cost" do
      products=Product.search({min_cost:1000})
      expect(products.count).to eql(6)
    end
    it "return collect products list with empty term search, with min_cost and max_cost" do
      products=Product.search({min_cost:1000,max_cost: 9999})
      expect(products.count).to eql(3)
    end
  end
end
