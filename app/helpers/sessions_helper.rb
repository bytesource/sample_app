module SessionsHelper



  def sign_in(user)
#   session[:current_user_id] = [user.id, user.salt]
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
#   session[:current_user_id] = nil
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # The one-line method body just sets an instance variable @current_user, 
  # effectively storing the user for later use.
  def current_user=(user)
    @current_user = user
  end

  # Getter
  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  # ----------------------------------------
  # functions for befor_filter

  def deny_access
    store_location
    flash[:notice] = "Please sign in to access this page."
    redirect_to signin_path
    # Short version: Setting flash[:notice] by passing an options hash to the redirect_to function.
    # redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def current_user?(user)
    user == current_user
  end

  # ------------------------------------------
  
  # Needed in the Sessions controller create action to redirect after successful signin
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end


  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
#     session[:current_user_id] || [nil, nil]
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
