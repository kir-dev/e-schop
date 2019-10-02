class AddNumberToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :number, :integer, default: 0
  end
end
