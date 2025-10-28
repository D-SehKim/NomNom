class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :item_type
      t.date :expires_at

      t.timestamps
    end
  end
end
