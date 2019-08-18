class Product < ApplicationRecord
  has_one :category
  has_one_attached :photo

  def thumb
    self.photo.variant(resize: '300x300').processed
  end

  def thumb_list
    self.photo.variant(resize: '320x320!').processed
  end



  def thumb_cart
    self.photo.variant(resize: '100x100!').processed
  end
  
end
