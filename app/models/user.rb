class User < ActiveRecord::Base
  attr_accessible :user_name, :password, :password_confirmation
  has_secure_password

  before_save :create_remember_token

  validates_uniqueness_of :user_name
  validates :user_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def name
    user_name
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
