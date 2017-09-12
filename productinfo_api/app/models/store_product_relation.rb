class StoreProductRelation < ApplicationRecord
  validates :stock, presence:true
  belongs_to :store
  belongs_to :product
end
