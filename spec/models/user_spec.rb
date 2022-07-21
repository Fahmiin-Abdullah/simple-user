require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'callbacks' do
    context 'when new user created' do
      it 'initializes api key' do
        user = User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@email.com', password: 'password')
        expect(user.reload.api_key).not_to be_blank
      end
    end
  end
end
