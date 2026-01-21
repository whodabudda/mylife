class User < ActiveRecord::Base    

    before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

	validates :first_name, presence: true, length: {maximum: 30 }
	validates :last_name, presence: true, length: {maximum: 50 }
	validates :username, presence: true, length: {maximum: 255 }
	has_secure_password
end
