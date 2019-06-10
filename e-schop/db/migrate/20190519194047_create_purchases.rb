class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.integer :buyer_id
      t.integer :good_id
      t.integer :number

      t.timestamps
    end
  end
end
