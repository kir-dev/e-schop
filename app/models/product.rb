# frozen_string_literal: true

class Product < ApplicationRecord
  has_one :category
  has_one_attached :photo

  def thumb
    photo.variant(resize: '300x300').processed
  end

  def thumb_list
    byebug
    photo.variant(resize: '320!x320!').processed
  end

  def thumb_cart
    photo.variant(resize: '100x100!').processed
  end
end
