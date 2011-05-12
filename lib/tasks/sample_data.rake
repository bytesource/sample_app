require 'faker'

namespace :db do
  desc "Fill database with sample data"
  # task :populate => :environment do
  # Ensures that the Rake task has access to the local Rails enviroment,
  # including the User model (and hence User.create!).
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name                  => "Stefan Rohlfing",
                         :email                 => "stefan.rohlfing@gmail.com",
                         :password              => "moinmoin",
                         :password_confirmation => "moinmoin")
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
end

# Run with
# rake db:populate
