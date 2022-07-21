class EncryptionService
  require 'jwt'

  def initialize(user)
    @api_key = user.api_key
  end

  def encrypt
    JWT.encode(@api_key, ENV['ENCRYPTOR_KEY_PHRASE'], ENV['ENCRYPTOR_ALGORITHM'])
  end

  def valid_token?(token)
    decrypted_data = JWT.decode(token, ENV['ENCRYPTOR_KEY_PHRASE'], true, { algorithm: ENV['ENCRYPTOR_ALGORITHM'] })

    @api_key == decrypted_data.first
  rescue StandardError
    false
  end
end