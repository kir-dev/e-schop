class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.column :username, :string
      t.column :password_digest, :string
      t.column :roomnumber, :integer
      t.timestamps
    end
  end
end
