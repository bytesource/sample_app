# == Schema Information
# Schema version: 20110515061748
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  # 'has' meaning 'owns'. This definition becomes important when to decide
  # on which model to add a 'has_one' association.
  has_many :microposts,    :dependent   => :destroy
  has_many :relationships, :foreign_key => "follower_id", # the default would look for a foreign key 'user_id'
                           :dependent   => :destroy
  has_many :following,     :through     => :relationships,
                           :source      => :followed   # :source => name of foreign key without '_id'
  # following = @user --> @other_user
  # Observation: follower_id = @user, followed_id = @other_user(s)

  # Without :source we would have to write:
  # has_many :followeds, :through => :relationships

  # Reverse relationship:
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name  => "Relationship",  # the default would look for a 'ReverseRelationship' class
                                   :dependent   => :destroy
  has_many :followers,             :through     => :reverse_relationships 
  # Because we write :followers, Rails knows that the foreign key is the singualar name + '_id', which is 'follower_id'

  # followers = @user <-- @other_user
  # Observation: followed_id = @user, @follower_id = @other_user(s)

  # ---------------------------------------------------------------------

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,     :presence     => true,
                       :length       => { :maximum => 50 }

  validates :email,    :presence     => true,
                       :format       => { :with => email_regex, :message => "is not correct!" },
                       :uniqueness   => { :case_sensitive => false }

  # Automatically creates the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  def after_initialize
    puts "You have initialized an object!"
  end

  # --------------------------------------------------------------------------
  # Micropost related

  def feed
    Micropost.from_users_followed_by(self)  # self = The instance calling this method (I think)
  end


  #----------------------------------------------------------------------------

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password) # Note: no 'do' here
    user = find_by_email(email)
    # user && user.has_password?(submitted_password) ? user : nil  
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    # In case of a password mismatch, we reach the end of the method, 
    # which automatically returns nil.
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  # Managing relationships

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
    # Equivalent: self.relationships.create!(...)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

 
  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
