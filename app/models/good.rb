class Good < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, optional: true
  validates :name, presence: true
  validates_numericality_of :price, presence: true
  has_one_attached :photo

  def thumb
    self.photo.variant(resize: '320x320!')

  end

  def thumb_list
    self.photo.variant(resize: '10x10!')
  end

  
end
