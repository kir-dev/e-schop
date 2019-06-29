class AddRoomnumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roomnumber, :integer
  end
end
