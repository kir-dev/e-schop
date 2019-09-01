# frozen_string_literal: true

class AddDeletedAtToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :deleted_at, :datetime
    add_index :purchases, :deleted_at
  end
end
