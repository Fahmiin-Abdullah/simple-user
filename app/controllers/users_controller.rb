class UsersController < ApplicationController
  before_action :authorize_user, only: %i[show update]
  before_action :authenticate_user, only: %i[update]

  def show
    payload = @user.as_json(only: %i[first_name last_name email])
    render json: payload, status: 200
  end

  def create
    user = User.new(user_params)
    if user.save
      payload = user.as_json(only: %i[first_name last_name email])
      payload[:token] = EncryptionService.new(user).encrypt

      render json: payload, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      payload = @user.as_json(only: %i[first_name last_name email])
      render json: payload, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  private

  def authorize_user
    @user = User.find(params[:id])
    token = request.headers['X-Api-Key']
    render json: { errors: ['Wrong API key'] }, status: 422 unless EncryptionService.new(@user).valid_token?(token)
  end

  def authenticate_user
    params.require(:password)
    render json: { errors: ['Wrong password'] }, status: 422 unless @user.authenticate(params[:password])
  end

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
