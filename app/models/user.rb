class User < ApplicationRecord
  attr_accessor :token

  has_secure_password

  validates :first_name, :last_name, :email, :password, presence: true

  before_create :initialize_api_key

  def initialize_api_key
    return if api_key.present?

    self.api_key = SecureRandom.hex(20)
  end
end
