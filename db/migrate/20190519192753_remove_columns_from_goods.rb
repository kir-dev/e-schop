class RemoveColumnsFromGoods < ActiveRecord::Migration[5.2]
  def change
    remove_column :goods, :buyer_id, :integer
    remove_column :goods, :bought, :boolean
    remove_column :goods, :original, :integer
  end
end
