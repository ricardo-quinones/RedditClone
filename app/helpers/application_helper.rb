module ApplicationHelper

  def current_user
    return nil unless session[:token]
    @current_user ||= User.find_by_token(session[:token])
  end

  def current_user=(user)
    @current_user = user
    @current_user.reset_token!
    session[:token] = @current_user.token
  end

  def signed_in?
    !!current_user
  end

  def logout_user!
    self.current_user.reset_token!
    session[:token] = nil
  end

  def must_sign_in
    redirect_to new_session_url unless signed_in?
  end
end
