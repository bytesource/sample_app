class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create] 
  before_filter :correct_user, :only   => [:edit, :update]
  before_filter :admin_user,   :only   => [:destroy]

  before_filter :logged_in_user, :only => [:new, :create]

# -----------------------------------------------------------------

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      # Shortcut for user_path(@user) -- as seen before inside link_to
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])  
    # Returns a WillPaginate::Collection that 'will_paginate' expects as a parameter. 
    # <% @users.each do |user| %> also works with WillPaginate::Collection.
  end


  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def edit
    # The 'correct_user' before filter already defines @user we can omit it here.
    # @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    # The 'correct_user' before filter already defines @user we can omit it here.
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    name = user.name
    # Only admin users can reach the 'destroy' action, so the current user must be an admin.
    if(current_user?(user)) 
      flash[:error] = "Admin users cannot delete themselves."
      redirect_to(users_path)
    else
      user.destroy
      flash[:success] = "Deleted #{name}"
      redirect_to(users_path)
    end
  end

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

# -----------------------------------------------------------------------

  def show_follow(action)
    @title = action.to_s.capitalize
    @user  = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render :show_follow  # This is the same as "render 'show_follow'"
    # 'render' renders a view (= template), but 
    # does not change the URL the corresponding actions was called from.
    # So here, after loading 'show_follow.html.erb', the brower address will still be /users/:id/following.
  end

  # send method:
  # Invokes the method identified by symbol, passing it any arguments specified. 
  # http://apidock.com/ruby/Object/send
  # Example:
  #
  # class Klass
  #   def hello(*args)
  #     "Hello " + args.join(' ')
  #   end
  # end
  # k = Klass.new
  # k.send :hello, "gentle", "readers"   #=> "Hello gentle readers"


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def logged_in_user
      redirect_to(root_path) if signed_in?
    end
end
