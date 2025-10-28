class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.integer :total_calories

      t.timestamps
    end
  end
end
