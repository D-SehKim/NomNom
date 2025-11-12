class CreateBudgetItems < ActiveRecord::Migration[8.1]
  def change
    create_table :budget_items do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
