class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    if !@user
      render json: {
        error: "User with id #{params[:id]} not found."
      }, status: :not_found
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".welcome_to_the_sample_app"
      redirect_to @user
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
