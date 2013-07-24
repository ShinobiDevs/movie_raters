require 'spec_helper'

describe LikesController do
  before(:each) do
    User.destroy_all
    @user = User.create(email: Faker::Internet.email, name: Faker::Name.name)
    Movie.destroy_all
    @movie = Movie.create(name: Faker::Lorem.words(2).join, year: rand(100) + 1910)
  end

  describe "#index" do
    it "should return liked movies ids for a given existing user" do
      @user.like!(@movie)
      get :index, {user_id: @user.id, format: :json}
      response.code.should eq("200")
      JSON.parse(response.body)["likes"].should eq([@movie.id.to_s])
    end

    it "should respond with 404 for a non existant user" do
      get :index, {user_id: 12312332, format: :json}
      response.code.should eq("404")
    end
  end

  describe "#create" do
    it "should respond with '201 Created' for a valid user and movie like" do
      post :create, {user_id: @user.id, id: @movie.id, format: :json}
      response.code.should eq("201")
    end

    it "should respond with a 404 for a non existant user" do
      post :create, {user_id: 12312332, id: @movie.id, format: :json}
      response.code.should eq("404")
    end

    it "should respond with a 404 for a non existant movie" do
      post :create, {user_id: @user.id, id: 1231232, format: :json}
      response.code.should eq("404")
    end

    it "should respond with a '304 Not modified' for an already liked movie" do
      @user.like!(@movie)
      post :create, {user_id: @user.id, id: @movie.id, format: :json}
      response.code.should eq("304")
    end
  end

  describe "#destroy" do
    it "should respond with '200 Created' for a valid user and movie unlike" do
      @user.like!(@movie)
      delete :destroy, {user_id: @user.id, id: @movie.id, format: :json}
      response.code.should eq("200")
    end

    it "should respond with a 404 for a non existant user" do
      delete :destroy, {user_id: 12312332, id: @movie.id, format: :json}
      response.code.should eq("404")
    end

    it "should respond with a 404 for a non existant movie" do
      delete :destroy, {user_id: @user.id, id: 1231232, format: :json}
      response.code.should eq("404")
    end

    it "should respond with a '304 Not modified' for an already unliked movie" do
      delete :destroy, {user_id: @user.id, id: @movie.id, format: :json}
      response.code.should eq("304")
    end
  end
end