class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def login; end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.not_found"
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "sign_up.welcome"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
