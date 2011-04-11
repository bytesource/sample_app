# By putting the factories.rb file in the spec/ directory, we arrange for RSpec 
# to load our factories automatically whenever the tests run.
# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Stefan Rohlfing"
  user.email                 "stefan.rohlfing@gmail.com"
  user.password              "secret"
  user.password_confirmation "secret"
end

