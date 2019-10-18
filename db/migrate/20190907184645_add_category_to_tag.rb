class AddCategoryToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :category, :boolean
  end
end
