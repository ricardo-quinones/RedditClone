class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
    params[:user][:email],
    params[:user][:password]
    )

    if @user.nil?
      @user = User.new
      flash.now[:errors] = "Invalid Email/Password Combination"
      render :new
    else
      flash[:success] = "Welcome back, #{@user.email}!"
      self.current_user = @user
      redirect_to links_url
    end
  end

  def destroy
    logout_user!
    redirect_to new_session_url
  end
end
