json.extract! product, :id, :name, :image_uri, :text, :cost, :created_at, :updated_at
json.url product_url(product, format: :json)
