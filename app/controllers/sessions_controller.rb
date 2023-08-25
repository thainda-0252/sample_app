class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params.dig(:session, :email).downcase)
    check_save user
  end

  def check_save user
    if user.try(:authenticate, params.dig(:session, :password))
      forwarding_url = session[:following_url]
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      log_in user
      redirect_back_or forwarding_url || user
    else
      flash.now[:danger] = t "login.message.danger"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
