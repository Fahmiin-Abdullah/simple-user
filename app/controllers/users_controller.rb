class UsersController < ApplicationController
  before_action :authorize_user, only: %i[show update]
  before_action :authenticate_user, only: %i[update]

  def show
    render json: @user.as_json(except: %i[id password_digest created_at updated_at]), status: 200
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user.as_json(except: %i[id password_digest created_at updated_at]), status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: @user.as_json(except: %i[id password_digest created_at updated_at]), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  private

  def authorize_user
    @user = User.find(params[:id])
    render json: { errors: ['Wrong API key'] }, status: 422 unless @user.api_key == request.headers['X-Api-Key']
  end

  def authenticate_user
    params.require(:password)
    render json: { errors: ['Wrong password'] }, status: 422 unless @user.authenticate(params[:password])
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
