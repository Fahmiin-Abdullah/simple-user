class UsersController < ApplicationController
  before_action :authorize_user, only: %i[show update]
  before_action :authenticate_user, only: %i[update]

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.token = EncryptionService.new(@user).encrypt
      render :create, status: 200, location: @user
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render :show, status: 200, location: @user
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
