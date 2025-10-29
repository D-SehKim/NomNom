class RemoveCaloriesFromRecipeIngredients < ActiveRecord::Migration[8.1]
  def change
    remove_column :recipe_ingredients, :calories, :integer
  end
end
