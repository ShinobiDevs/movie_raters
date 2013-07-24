require 'spec_helper'

describe MoviesController do
  before(:each) do
    User.destroy_all
    @user = User.create(email: Faker::Internet.email, name: Faker::Name.name)
    Movie.destroy_all
    @movie = Movie.create(name: Faker::Lorem.words(2).join, year: rand(100) + 1910)
  end

  describe "#index" do
    it "should return all movies" do
      get :index, format: :json
      assigns[:movies].should eq([@movie])
    end
  end

  describe "#create" do
    it "should create a movie if valid attributes supplied" do
      post :create, {movie: {name: Faker::Lorem.words(2).join, year: 2000},format: :json}
      response.code.should eq("201")
    end

    it "should respond with 422 for a validation error (missing :year)" do
      post :create, {movie: {name: Faker::Lorem.words(2).join}, format: :json}
      response.code.should eq("422")
      JSON.parse(response.body).has_key?("errors").should be_true
    end
  end

  describe "#show" do
    it "should return a valid response for an existing movie" do
      get :show, {id: @movie.id, format: :json}
      response.code.should eq("200")
      parsed_resp = JSON.parse(response.body)
      parsed_resp["id"].should eq(@movie.id)
    end

    it "should respond with 404 for a non existant movie" do
      get :show, {id: 432234433, format: :json}
      response.code.should eq("404")
    end
  end

  describe "#update" do
    it "should successfully update an existing movie with valid attributes" do
      put :update, {id: @movie.id, movie: {name: "New Name"}, format: :json}
      response.code.should eq("204")
      response.body.should be_empty
    end

    it "should respond with 404 if the requested movie is not found" do
      put :update, {id: 232322233, movie: {name: "New Name"}, format: :json}
      response.code.should eq("404")
    end

    it "should responsd with 422 if update returns an error (validation error)" do
      put :update, {id: @movie.id, movie: {year: nil}, format: :json}
      response.code.should eq("422")
    end
  end

  describe "#destroy" do
    it "should successfully destroy an existing movie" do
      delete :destroy, {id: @movie.id, format: :json}
      response.code.should eq("200")
    end

    it "should respond with 404 for non existing movie" do
      delete :destroy, {id: 123123332, format: :json}
      response.code.should eq("404")
    end
  end
end