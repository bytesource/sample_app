# == Schema Information
# Schema version: 20110515061748
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  # Note: The foreign key always goes on the table for the class declaring the 'belongs_to' association.
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true


  default_scope :order => 'microposts.created_at DESC'

  # Return microposts from the users being followed by the given user.
  scope         :from_users_followed_by, lambda { |user| followed_by(user) }

# -------------------------------------------

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", {:user_id => user})
    end
    # Note:
    # We have replaced
    # where("... OR user_id = ?", user)
    # with the equivalent
    # where("... OR user_id = :user_id", { :user_id => user })

    # Solution from Stackoverflow:
    # http://stackoverflow.com/questions/4855851/rubytutorial-org-invalid-sql-statement-generates-500-response-on-pageshome
    #
    # def self.from_users_followed_by(user)
    #   followed_ids = user.following.map(&:id) + user.id
    #   where(:user_id => followed_ids)
    # end
end



# Updating the Schema
# Associations are extremely useful, but they are not magic. 
# You are responsible for maintaining your database schema to match your associations. 
# In practice, this means two things, depending on what sort of associations you are creating. 
# For belongs_to associations you need to create foreign keys, 
# and for has_and_belongs_to_many associations you need to create the appropriate join table.
#
# If you create an association some time after you build the underlying model, 
# you need to remember to create an add_column migration to provide the necessary foreign key.
#
# Methods Added by belongs_to
# association(force_reload = false)
# association=(associate)
# build_association(attributes = {})
# create_association(attributes = {})
# 
# build_association(attributes = {})
# This object will be instantiated from the passed attributes, 
# and the link through this object’s foreign key will be set, 
# but the associated object will NOT yet be saved.
# 
# create_association(attributes = {})
# The associated object will be saved (assuming that it passes any validations).
