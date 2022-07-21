require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@email.com', password: 'password', api_key: '12345') }

  describe '#show' do
    context 'with valid params and api key' do
      it 'returns user details' do
        request.headers['X-Api-Key'] = '12345'
        get :show, params: { id: user.id }
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(result['first_name']).to eq('John')
        expect(result['last_name']).to eq('Doe')
        expect(result['email']).to eq('john.doe@email.com')
        expect(result['api_key']).to eq('12345')
      end
    end

    context 'with wrong api key' do
      it 'return error' do
        request.headers['X-Api-Key'] = '67890'
        get :show, params: { id: user.id }
        result = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(result['errors']).to include('Wrong API key')
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      {
        first_name: 'Brad',
        last_name: 'Pitt',
        email: 'brad.pitt@email.com',
        password: 'password'
      }
    end

    context 'with valid params' do
      it 'creates new user' do
        post :create, params: valid_params
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(result['first_name']).to eq('Brad')
        expect(result['last_name']).to eq('Pitt')
        expect(result['email']).to eq('brad.pitt@email.com')
        expect(result).to have_key('api_key')
      end
    end

    context 'with invalid params' do
      context 'when empty first name' do
        it 'returns error' do
          valid_params.delete(:first_name)
          post :create, params: valid_params
          result = JSON.parse(response.body)

          expect(response).to have_http_status(422)
          expect(result['errors']).to include("First name can't be blank")
        end
      end

      context 'when empty last name' do
        it 'returns error' do
          valid_params.delete(:last_name)
          post :create, params: valid_params
          result = JSON.parse(response.body)

          expect(response).to have_http_status(422)
          expect(result['errors']).to include("Last name can't be blank")
        end
      end

      context 'when empty emil' do
        it 'returns error' do
          valid_params.delete(:email)
          post :create, params: valid_params
          result = JSON.parse(response.body)

          expect(response).to have_http_status(422)
          expect(result['errors']).to include("Email can't be blank")
        end
      end

      context 'when empty password' do
        it 'returns error' do
          valid_params.delete(:password)
          post :create, params: valid_params
          result = JSON.parse(response.body)

          expect(response).to have_http_status(422)
          expect(result['errors']).to include("Password can't be blank")
        end
      end
    end
  end

  describe '#update' do
    let(:valid_params) do
      {
        id: user.id,
        first_name: 'Angelina',
        last_name: 'Jolie',
        email: 'angeline.jolie@email.com',
        password: 'password'
      }
    end

    context 'with valid params and api key' do
      it 'updates user details' do
        request.headers['X-Api-Key'] = '12345'
        put :update, params: valid_params
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(result['first_name']).to eq('Angelina')
        expect(result['last_name']).to eq('Jolie')
        expect(result['email']).to eq('angeline.jolie@email.com')
      end
    end

    context 'when wrong api key' do
      it 'return error' do
        request.headers['X-Api-Key'] = '67890'
        put :update, params: valid_params
        result = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(result['errors']).to include('Wrong API key')
      end
    end

    context 'when wrong password' do
      it 'return error' do
        valid_params[:password] = 'password1'
        request.headers['X-Api-Key'] = '12345'
        put :update, params: valid_params
        result = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(result['errors']).to include('Wrong password')
      end
    end
  end
end
