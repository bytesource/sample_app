class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_path
    else
      # calls 'home' action of Pages controller. Its view requires a @feed_items variable
      # in the partial /shared_feed.html.erb.
      @feed_items = [] # paginate does not work here (for some reason).
      render 'pages/home'
    end
  end

  def destroy
    @micropost.delete
    redirect_back_or root_path
  end

  # ----------------------------
  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to(root_path) unless current_user?(@micropost.user)
  end
end
