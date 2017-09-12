class Product < ApplicationRecord
  mount_uploader :image_uri,ImageUploader
  validates :name, presence: true
  validates :name, length: {maximum: 100,too_long: 'name is too long'}
  validates :text, length: {maximum: 500,too_long: 'text is too long'}
  has_many :store_product_relations
  has_many :stores,through: :store_product_relations
  def self.search(search_object)
    products=order('name')
    if term = search_object[:q]
      range = search_object[:search_target]
      products=products.where(['name like ?',"%#{term}"]) if ['name','name_and_text'].include?(range)
      products=products.or(order('name').where(['text like ?',"%#{term}"])) if range == 'name_and_text'
    end
    if max_cost=search_object[:max_cost]
      products=products.where('cost <= ?',max_cost)
    end
    if min_cost=search_object[:min_cost]
      products=products.where('cost >= ?',min_cost)
    end
    return products
  end
end
