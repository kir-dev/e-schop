class AddDeletedAtToGoods < ActiveRecord::Migration[5.2]
  def change
    add_column :goods, :deleted_at, :datetime
    add_index :goods, :deleted_at
  end
end
