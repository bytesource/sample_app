class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

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
    user.destroy
    flash[:success] = "Deleted #{name}"
    redirect_to(users_path)
  end
end

# -----------------------------------------------------------------------

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
