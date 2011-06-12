class RelationshipsController < ApplicationController
  before_filter :authenticate

#   <%= form_for CURRENT_USER.relationships.
#                             build(:followed_id => @user.id) do |f| %>      *)
#     <div><%= f.hidden_field :followed_id %></div>
#     <div class="actions"><%= f.submit "Follow" %></div>
#   <% end %>
#   
#   HTML output:
#   <input id="relationship_followed_id" 
#          name="relationship[followed_id]"
#          type="hidden" value="3" />
#
# value="3" equals @user.id and is also the id shown in the URL.

  def create # /relationships 
             # (As the URL passed to 'create' never contains an id, we have to send it in an hidden field).
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)  # follow! --> relationships.create!(:followed_id => @user.id), NOTE: follower_id is automatically set.
    message = "You now follow #{@user.name}"  
    # respond_to takes the appropriate action depending on the kind of request.
    respond_to do |format|
      format.html do
        # The message of flash will be displayed on the NEXT request (redirect_to leads to a new request).
        flash[:success] = message # views/layouts/application.html.erb
        redirect_to @user  # 1)
      end
      format.js do
        # The message of flash.now will be displayed on the SAME request (Ajax does not lead to a new request).
        flash.now[:success] = message 
        # Automatically calls create.js.erb:
        # $("flash").update("<%= escape_javascript(render('shared/flashi')) %>")
        # Note: Had to rename the partial '_flash.html.erb' to 'flashi.html.erb', otherwise it would not load.
      end
    end
  end

  # *)
  # OBSERVATION:
  # We have to create a relationships object in 'form_for' so that Rails
  # can infer the correct controller (Relationships) and action (create).

  # 1)
  # 'redirect_to @user' is a shortcut for 'redirect_to user_path(@user)'
  # which redirects to /show/:id (back to the page where 'create' was called from)

  # -----------------------------------------------------

  #   <%= form_for CURRENT_USER.relationships.find_by_followed_id(@user),
  #                             :html => { :method => :delete } do |f| %>
  #     <div class="actions"><%= f.submit "Unfollow" %></div>
  #   <% end %>
  
  #  <form action="/relationships/90" class="edit_relationship" id="edit_relationship_90" method="post">
  #    <input name="_method" type="hidden" value="delete" />
  #  <div class="actions">
  #    <input id="relationship_submit" name="commit" type="submit" value="Unfollow" /></div>

  def destroy # relationships/:id
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    message = "You no longer follow #{@user.name}"  
    respond_to do |format|
      format.html do
        flash[:success] = message # views/layouts/application.html.erb
        redirect_to @user
      end
      format.js do
        flash.now[:success] = message 
        # Automatically calls destroy.js.erb
      end
    end
  end


  # 2)
  # Relationship.find(1)
  # => #<Relationship id: 1, follower_id: 1, followed_id: 2,...>
  # Relationship.find(1).followed
  # => #<User id: 2, name: "Reina Flatley MD",...>
  # Relationship.find(1).follower
  # #<User id: 1, name: "Example User",...>
  # Observation: '.followed' and '.follower' are getter methods for 'followed_id' and 'follower_id'.

end

