class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.not_found"
    redirect_to root_path
  end

  def index
    @pagy, @users = pagy(User.all, items: Settings.pages.items)
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "activation.confirm"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.success"
    else
      flash[:danger] = t "users.destroy.failed"
    end
    redirect_to users_path
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    flash[:danger] = t "login.please_login"
    store_location
    redirect_to login_path
  end

  # Confirms the correct user.
  def correct_user
    return if current_user?(@user)

    flash[:warning] = t "users.edit.cant_edit"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
