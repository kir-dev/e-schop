# frozen_string_literal: true

class CreateIntrests < ActiveRecord::Migration[5.2]
  def change
    create_table :intrests do |t|
      t.belongs_to :user, index: true
      t.belongs_to :tag, index: true
      t.integer :rate

      t.timestamps
    end
  end
end
