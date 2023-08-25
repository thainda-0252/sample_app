module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  # Forgets a persistent session.
  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # Returns true if the given user is the current user.
  def current_user? user
    user && user == current_user
  end

  def redirect_back_or default
    redirect_to session[:following_url] || default
    session.delete(:following_url)
  end

  def store_location
    session[:following_url] = request.original_url if request.get?
  end
end
