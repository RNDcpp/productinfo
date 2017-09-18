json.extract! product, :id, :name,:cost,:image_uri,:text, :stock, :created_at, :updated_at
json.url product_url(product, format: :json)
