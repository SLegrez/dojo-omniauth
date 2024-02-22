class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[facebook google_oauth2 linkedin]
  validates :first_name, :last_name, :email, presence: true

  def self.from_omniauth(auth, provider)
    return unless auth.present?

    User.find_by(email: auth.info.email, "#{provider}_uid": auth.uid)
  end
end
