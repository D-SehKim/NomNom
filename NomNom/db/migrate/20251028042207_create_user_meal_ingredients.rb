class CreateUserMealIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :user_meal_ingredients do |t|
      t.references :user_meal, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
