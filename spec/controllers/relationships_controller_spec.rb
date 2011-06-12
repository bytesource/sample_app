require 'spec_helper'

describe RelationshipsController do

  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
    end

    it "should create a relationship" do
      lambda do
        post :create, :relationship => { :followed_id => @followed } # 1)
        response.should be_redirect
      end.should change(Relationship, :count).by(1)
    end

    it "should create a relationship using Ajax" do
      lambda do
        # xhr = XmlHttpRequest
        xhr :post, :create, :relationship => { :followed_id => @followed }
        response.should be_success
      end.should change(Relationship, :count).by(1)
    end
  end

  # 1)
  #  :relationship => { :followed_id => @followed }
  #  simulates the submission of the form with the hidden field given by
  #  <%= f.hidden_field :followed_id %>

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it "should destroy a relationship" do
      lambda do
        delete :destroy, :id => @relationship
        response.should be_redirect
      end.should change(Relationship, :count).by(-1)
    end

    it "should destroy a relationship using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @relationship
        response.should be_succes
      end.should change(Relationship, :count).by(-1)
    end
  end
end
