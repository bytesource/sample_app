# By putting the factories.rb file in the spec/ directory, we arrange for RSpec 
# to load our factories automatically whenever the tests run.
# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Example User"
  user.email                 "example@railstutorial.org"
  user.password              "secret"
  user.password_confirmation "secret"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
