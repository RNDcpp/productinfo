class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, limit: 100, null: false
      t.string :image_uri 
      t.string :text, limit: 500, default: ''
      t.integer :cost

      t.timestamps
    end
  end
end
