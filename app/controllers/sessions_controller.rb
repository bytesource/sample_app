class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render('new')
    else
      sign_in user
      # session[:return_to] will contain an URL (set in the body of 'deny_access') if the 'create' action 
      # was triggered after trying to access a restricted page when not signed-in.
      redirect_back_or user
    end
  end

  def destroy
    sign_out 
    redirect_to root_path
  end

end
