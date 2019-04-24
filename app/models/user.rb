class User < ApplicationRecord
    has_many :goods
    has_secure_password          
end
