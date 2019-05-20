class Good < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, optional: true
  has_one :category
  has_one_attached :photo
  validates :name, presence: true
  validates_numericality_of :price, presence: true
  validates_numericality_of :category_id, presence: true
end
