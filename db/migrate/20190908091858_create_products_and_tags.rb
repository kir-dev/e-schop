class CreateProductsAndTags < ActiveRecord::Migration[5.2]
  create_table :products_tags, id: false do |t|
    t.belongs_to :product, index: true
    t.belongs_to :tag, index: true
  end
end
