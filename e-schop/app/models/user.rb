class User < ApplicationRecord
    has_many :goods
    has_secure_password
    
    acts_as_messageable

    def name
        "#{username}"
    end

    def mailboxer_email(object)
        nil
    end
end
