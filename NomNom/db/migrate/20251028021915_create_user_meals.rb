class CreateUserMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :user_meals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :servings

      t.timestamps
    end
  end
end
