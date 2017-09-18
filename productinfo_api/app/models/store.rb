class Store < ApplicationRecord
  validates :name, presence: true
  has_many :store_product_relations,dependent: :delete_all
  has_many :products,through: :store_product_relations
  def self.search(name)
    return self.where('name like ?',"%#{name}%")
  end
end
