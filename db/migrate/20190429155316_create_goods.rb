# frozen_string_literal: true

class CreateGoods < ActiveRecord::Migration[5.2]
  def change
    create_table :goods do |t|
      t.string :name
      t.integer :category_id
      t.text :description
      t.integer :number
      t.integer :seller_id
      t.integer :price
      t.integer :product_id

      t.timestamps
    end
  end
end
