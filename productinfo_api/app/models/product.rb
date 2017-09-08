class Product < ApplicationRecord
  mount_uploader :image_uri,ImageUploader
  validates :name, presence: true
  validates :name, length: {maximum: 100}
  validates :text, length: {maximum: 500}
  def self.search(search_object)
    if term=search_object[:search_term]
      range = search_object[:search_target]
      products=where('name like ?',term) if ['name','name_and_text'].include?(range)
      products=products.or(where('text like ?',term))if range == 'name_and_text'
    end
    if max_cost=search_object[:max_cost]
      products=( products )? products.where('cost <= ?',max_cost) : where('cost <= ?',max_cost)
    end
    if min_cost=search_object[:min_cost]
      products=( products )? products.where('cost >= ?',min_cost) : where('cost >= ?',min_cost)
    end
    return products
  end
end
