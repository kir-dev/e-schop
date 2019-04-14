class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.column :name, :string
      t.timestamps
    end
    Category.create :name => "Kaja"
    Category.create :name => "Ital"
    Category.create :name => "Stb"
     
  end
end
