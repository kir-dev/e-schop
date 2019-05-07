class Good < ApplicationRecord
    belongs_to :user, optional: true
    has_one :category
    validates :name, presence: true
    validates_numericality_of :price, presence: true
    validates_numericality_of :category_id, presence: true    
    has_one_attached :photo

    def thumb
       self.photo.variant(resize: "300x300").processed 
    end
end
