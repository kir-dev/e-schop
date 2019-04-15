class Good < ApplicationRecord
    belongs_to :user, optional: true
    has_one :category
    validates :name, presence: true
    validates_numericality_of :price, presence: true
    validates_numericality_of :category_id, presence: true
    validates_numericality_of :seller_id, presence: true
    
end
