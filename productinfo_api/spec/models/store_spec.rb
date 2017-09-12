require 'rails_helper'

RSpec.describe Store, type: :model do
  context 'get and create shop' do
    before do
      @product=create(:product_hoge_fuga_1000)
      @product2=create(:product_fuga_fuga_1000)
      @product3=create(:product_hoge_hoge_100)
      @store=create(:store)
      StoreProductRelation.create(store:@store,product:@product,stock:12)
      StoreProductRelation.create(store:@store,product:@product2,stock:20)
    end
    it 'should get products 'do 
      products=@store.products
      expect(products.count).to eq(2)
      product_obtained = products.find_by(id:@product.id)
      expect(product_obtained).to eq(@product)
      product_obtained = products.find_by(id:@product2.id)
      expect(product_obtained).to eq(@product2)
    end
  end
  context 'search' do
    before do
      @hoge1=create(:store_hoge)
      @hoge2=create(:store_hoge)
      @fuga=create(:store_fuga)
    end
    it 'should get collect products' do
      stores=Store.search('hoge')
      expect(stores.count).to eq(2)
      expect(stores.find_by(id:@hoge1.id)).to eq(@hoge1)
      expect(stores.find_by(id:@hoge2.id)).to eq(@hoge2)
      stores=Store.search('fuga')
      expect(stores.count).to eq(1)
      expect(stores.find_by(id:@fuga.id)).to eq(@fuga)
    end
  end
end
