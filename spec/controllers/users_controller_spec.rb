require 'spec_helper'

describe UsersController do

  before(:each) do
    User.destroy_all
    @user = User.create(email: Faker::Internet.email, name: Faker::Name.name)
  end
  
  describe "#index" do
    it "should return all users" do
      get :index, format: :json
      assigns[:users].should eq([@user])
    end
  end

  describe "#create" do
    it "should create a user if valid attributes supplied" do
      post :create, {user: {email: Faker::Internet.email, name: "Tester"},format: :json}
      response.code.should eq("201")
    end

    it "should respond with 422 if a duplicate user email is created" do
      post :create, {user: {email: @user.email, name: "duplicate emailer"}, format: :json}
      response.code.should eq("422")
      JSON.parse(response.body).has_key?("errors").should be_true
    end
  end

  describe "#show" do
    it "should return a valid response for an existing user" do
      get :show, {id: @user.id, format: :json}
      response.code.should eq("200")
      parsed_resp = JSON.parse(response.body)
      parsed_resp["id"].should eq(@user.id)
    end

    it "should respond with 404 for a non existant user" do
      get :show, {id: 432234433, format: :json}
      response.code.should eq("404")
    end
  end

  describe "#update" do
    it "should successfully update an existing user with valid attributes" do
      put :update, {id: @user.id, user: {name: "New Name"}, format: :json}
      response.code.should eq("204")
      response.body.should be_empty
    end

    it "should respond with 404 if the requested user is not found" do
      put :update, {id: 232322233, user: {name: "New Name"}, format: :json}
      response.code.should eq("404")
    end

    it "should responsd with 422 if update returns an error (validation error)" do
      @user2 = User.create(email: Faker::Internet.email, name: Faker::Name.name)
      put :update, {id: @user.id, user: {email: @user2.email}, format: :json}
      response.code.should eq("422")
    end
  end

  describe "#destroy" do
    it "should successfully destroy an existing user" do
      delete :destroy, {id: @user.id, format: :json}
      response.code.should eq("200")
    end

    it "should respond with 404 for non existing user" do
      delete :destroy, {id: 123123332, format: :json}
      response.code.should eq("404")
    end
  end
end