class Product < ApplicationRecord
  has_one :category
  has_one_attached :photo

  def thumb
    self.photo.variant(resize: '300x300!')
  end

  def thumb_list
    self.photo.variant(resize: '320x320!')
  end
end
