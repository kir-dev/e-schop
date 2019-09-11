class AddWantEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :want_email, :boolean, default: true
  end
end
