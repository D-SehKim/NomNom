class MakeRecipeIdNullableInUserMeals < ActiveRecord::Migration[7.1]
  def change
    change_column_null :user_meals, :recipe_id, true
  end
end
