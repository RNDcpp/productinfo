require 'rails_helper'

RSpec.describe StoreProductRelation, type: :model do
  before do
    @store=create(:store)
    @product=create(:product_hoge_hoge_100)
  end
  it 'create_product_by_id' do
    StoreProductRelation.new(product_id:@product.id,store_id:@store.id,stock:12)
    flag=@store.save
    puts @store.errors
    expect(flag).to be_truthy
  end
end
