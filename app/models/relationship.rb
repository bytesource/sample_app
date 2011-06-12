class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  # The follower_id attribute is not be accessible; 
  # otherwise, malicious users could force other users to follow them.
  # followed_id: Identifies a user I FOLLOW.
  # follower_id: Identifies a user who FOLLOWS ME.

  belongs_to :follower, :class_name => "User" # = user who initialised the relationship
  belongs_to :followed, :class_name => "User"
  # Rails infers the names of the foreign keys from the corresponding symbols 
  # (i.e., follower_id from :follower)
  # Since there is neither a 'Followed' nor a 'Follower' model 
  # we need to supply the class name 'User'.

  validates :follower, :presence => true
  validates :followed, :presence => true


end
