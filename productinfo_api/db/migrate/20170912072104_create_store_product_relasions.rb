class CreateStoreProductRelasions < ActiveRecord::Migration[5.1]
  def change
    create_table :store_product_relasions do |t|
      t.references :store, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
