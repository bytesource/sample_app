require 'faker'

namespace :db do
  desc "Fill database with sample data"
  # task :populate => :environment do
  # Ensures that the Rake task has access to the local Rails enviroment,
  # including the User model (and hence User.create!).
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name                  => "Example User",
                       :email                 => "example@railstutorial.org",
                       :password              => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name     = Faker::Name.name
    email    = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(:name                  => name,
                 :email                 => email,
                 :password              => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first # same as users[0]
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) } # first user to follow the next 50 users
  followers.each { |follower| follower.follow!(user) } # users with ids 4 through 41 follow that user back
end
