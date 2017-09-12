require 'rails_helper'

RSpec.describe Store, type: :model do
  before do
    @product=create(:product_hoge_fuga_1000)
    @product2=create(:product_fuga_fuga_1000)
    @store=create(:store)
    StoreProductRelation.create(store:@store,product:@product)
    StoreProductRelation.create(store:@store,product:@product2)
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
