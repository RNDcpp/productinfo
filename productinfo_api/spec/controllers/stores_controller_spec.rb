require 'rails_helper'
RSpec.describe StoresController, type: :controller do
  before do
    @store=create(:store)
  end
  describe "POST #add_products" do
    it "create relation" do
      product=create(:product_hoge_hoge_100)
      expect {
        post :add_products, params: {id:@store.id,product_id:product.id,stock:12}
      }.to change(StoreProductRelation, :count).by(1)
    end

  end

end
