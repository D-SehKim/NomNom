class CreateGroceryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :grocery_items do |t|
      t.string :name, null: false
      t.string :quantity, default: "1"
      t.boolean :purchased, default: false
      t.references :user, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
