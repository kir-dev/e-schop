class Product < ApplicationRecord
  has_one :category
  has_one_attached :photo

  def thumb
    self.photo.variant(resize: '300x300').processed
  end

  def thumb_list
    self.photo.variant(resize: '150x150').processed
  end
end
