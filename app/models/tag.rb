class Tag < ApplicationRecord
    has_and_belongs_to_many :goods
    has_many :intrests
    has_many :users, through: :intrests
end
