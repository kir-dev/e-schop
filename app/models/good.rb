# frozen_string_literal: true

class Good < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, optional: true
  validates :name, presence: true
  validates_numericality_of :price, presence: true
  has_one_attached :photo
  has_and_belongs_to_many :tags

  def thumb
    photo.variant(resize: '300x300!').processed
  end

  def thumb_list
    photo.variant(resize: '320x320!').processed
  end

  def thumb_cart
    photo.variant(resize: '100x100!').processed
  end

  def floor
    seller = User.find_by_id(seller_id)
    seller.roomnumber ? seller.roomnumber / 100 : nil
  end
end
