class Good < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, optional: true
  validates :name, presence: true
  validates_numericality_of :price, presence: true
  has_one_attached :photo

  
end
