require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Sovonex International"
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user      = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following counts" do # See app/views/shared/_stats.html.erb
        get :home
        response.should have_selector("a", :href    => following_user_path(@user),
                                      :content => "0 following")
        response.should have_selector("a", :href    => followers_user_path(@user),
                                      :content => "1 follower")
      end

      # sovonex ---------------------------------------------
      # Homework: Add tests for the sidebar micropost counts (including proper pluralization).
      describe "user info partial" do

        #        Already signed in above
        #        before(:each) do
        #          @user = Factory(:user)
        #          test_sign_in(@user)
        #        end

        it "a single micropost should not trigger 'pluralize'" do

          mp1 = Factory(:micropost, :user => @user, :content => "Micropost 1")
          get :home
          response.should have_selector("span.microposts", :content => "1 micropost")
        end

        it "two microposts should trigger 'pluralize'" do
          mp1 = Factory(:micropost, :user => @user, :content => "Micropost 1")
          mp2 = Factory(:micropost, :user => @user, :content => "Micropost 2")
          get :home
          response.should have_selector("span.microposts", :content => "2 microposts")
        end
      end
      # sovonex end --------------------------------------------------
    end

    describe "GET 'contact'" do
      it "should be successful" do
        get 'contact'
        response.should be_success
      end

      it "should have the right title" do
        get 'contact'
        response.should have_selector("title", :content => @base_title + " | Contact")
      end
    end

    describe "Get 'about'" do
      it "should be successful" do
        get 'about'
        response.should be_success
      end

      it "should have the right title" do
        get 'about'
        response.should have_selector("title", :content => @base_title + " | About")
      end
    end

    describe "Get 'help'" do
      it "should be successful" do
        get 'help'
        response.should be_success
      end

      it "should have the right title" do
        get 'help'
        response.should have_selector("title", :content => @base_title + " | Help")
      end
    end
  end
end

