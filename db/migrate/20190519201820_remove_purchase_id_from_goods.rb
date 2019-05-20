class RemovePurchaseIdFromGoods < ActiveRecord::Migration[5.2]
  def change
    remove_column :goods, :purchase_id, :integer
  end
end
