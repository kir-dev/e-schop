class AddNumberToLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :levels, :number, :integer
  end
end
