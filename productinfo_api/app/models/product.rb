class Product < ApplicationRecord
  mount_uploader :image_uri,ImageUploader
  validates :name, presence: true
  validates :name, length: {maximum: 100}
  validates :text, length: {maximum: 500}
end
