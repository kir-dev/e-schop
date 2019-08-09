class CreateGoodsAndTags < ActiveRecord::Migration[5.2]
  create_table :goods_tags, id: false do |t|
    t.belongs_to :good, index: true
    t.belongs_to :tag, index: true
  end
end