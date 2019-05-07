class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :name
      t.float :avg_price
      t.integer :num
      t.integer :category_id

      t.timestamps
    end
  end
end
