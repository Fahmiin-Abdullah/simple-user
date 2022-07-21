require 'rails_helper'
require 'jwt'

RSpec.describe EncryptionService, type: :service do
  let!(:user) { User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@email.com', password: 'password') }
  let!(:token) { JWT.encode(user.api_key, ENV['ENCRYPTOR_KEY_PHRASE'], ENV['ENCRYPTOR_ALGORITHM']) }

  describe '::encrypt' do
    it 'encodes api key' do
      expect(EncryptionService.new(user).encrypt).to eq(token)
    end
  end

  describe '::valid_token?' do
    context 'when valid token' do
      it 'returns true' do
        expect(EncryptionService.new(user).valid_token?(token)).to be_truthy
      end
    end

    context 'when invalid token' do
      it 'returns false' do
        expect(EncryptionService.new(user).valid_token?('12345')).to be_falsy
      end
    end
  end
end
