class CreateGoods < ActiveRecord::Migration[5.2]
  def change
    create_table :goods do |t|
      t.column :name, :string
      t.column :price, :integer
      t.column :description, :text
      t.column :category_id, :integer
      t.column :seller_id, :integer
      t.column :buyer_id, :integer

      t.timestamps
    end
  end
end
