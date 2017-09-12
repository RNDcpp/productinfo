class Store < ApplicationRecord
  validates :name, presence: true
  has_many :store_product_relations
  has_many :products,through: :store_product_relations
end
