require 'spec_helper'

describe Movie do
  before(:each) do
    @user = User.create(email: Faker::Internet.email, name: Faker::Name.name)
    @movie = Movie.create(name: Faker::Lorem.words(2).join, year: rand(100) + 1910)
  end

  describe "#likes" do
    it "should be 0 for a non liked movie" do
      @movie.likes.should eq(0)
    end

    it "should increase by 1 for each like" do
      @user.like!(@movie)
      @movie.likes.should eq(1)
    end
  end

  describe "#liked_by_user_ids" do
    it "should be empty for a non liked movie" do
      @movie.liked_by_user_ids.should eq([])
    end

    it "should return an array of likers ids" do
      @user.like!(@movie)
      @movie.liked_by_user_ids.should include(@user.id.to_s)
    end
  end

  describe "#genres" do
    it "should be an empty string for a movie without genres" do
      @movie.genres.should be_blank
    end

    it "should return a comma separated string of genres for a movie with genres" do
      @movie = Movie.create(name: Faker::Lorem.words(2).join, year: rand(100) + 1910, genres: "drama, action")
      @movie.genres.should eq("action, drama")
    end
  end
end