class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(create edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)
  def new; end

  def edit; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_password.email.send"
      redirect_to root_url
    else
      flash.now[:danger] = t "forgot_password.email.not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("forgot_password.password.not_found"))
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      reset_session
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "forgot_password.password.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: (params[:email] || params.dig(:password_reset,
                                                              :email)&.downcase)
    return if @user

    flash[:danger] = t "forgot_password.user.not_found"
    redirect_to root_url
  end

  # Confirms a valid user.
  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "forgot_password.user.not_actived"
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "forgot_password.expired"
    redirect_to new_password_reset_url
  end
end
