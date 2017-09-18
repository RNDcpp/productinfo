class StoreProductRelation < ApplicationRecord
  validates :stock, presence:true
  validates :product_id, uniqueness:{ scope:[:product_id,:store_id] }
  belongs_to :store
  belongs_to :product
end
