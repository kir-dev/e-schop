# frozen_string_literal: true

class Product < ApplicationRecord
  include ApplicationHelper
  
  has_one_attached :photo
  has_and_belongs_to_many :tags
  after_save :set_filename

  def thumb
    photo.variant(resize: '300x300').processed
  end

  def thumb_list
    photo.variant(resize: '320!x320!').processed
  end

  def thumb_cart
    photo.variant(resize: '100x100!').processed
  end
end
