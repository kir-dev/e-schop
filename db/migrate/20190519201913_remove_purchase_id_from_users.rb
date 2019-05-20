class RemovePurchaseIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :purchase_id, :integer
  end
end
