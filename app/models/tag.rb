class Tag < ApplicationRecord
    has_and_belongs_to_many :goods
    has_many :intrests
    has_many :users, through: :intrests
    validate :name_must_be_lowercase

    def name_must_be_lowercase
        self.name=self.name.downcase
    end

end
