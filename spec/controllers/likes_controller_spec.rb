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
    end
  end

end