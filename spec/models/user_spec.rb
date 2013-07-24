require 'spec_helper'

describe User do
  before(:each) do
    @user = User.create(email: Faker::Internet.email, name: Faker::Name.name)
    @movie = Movie.create(name: Faker::Lorem.words(2).join, year: rand(100) + 1910)
  end

  describe "unique email" do
    it "should not allow duplicate emails for users" do
      lambda {
        User.create!(email: @user.email, name: "Duplicate email")
      }.should raise_error
    end
  end

  describe "#liked_movies_count" do
    it "should be 0 for a new user" do
      @user.liked_movies_count.should eq(0)
    end

    it "should increase by 1 when liking a movie" do
      @user.like!(@movie)
      @user.liked_movies_count.should eq(1)
    end

    it "should not allow double likes" do
      @user.like!(@movie)
      @user.like!(@movie)
      @user.liked_movies_count.should eq(1)
    end
  end

  describe "#liked_movies_ids" do

    it "should be empty for a new user" do
      @user.liked_movies_ids.should eq([])
    end

    it "should include a liked movie after liking it" do
      @user.like!(@movie)
      @user.liked_movies_ids.should include(@movie.id.to_s)
    end
  end

  describe "#likes_movie?" do
    it "should be false for non liked movie" do
      @user.likes_movie?(@movie).should be_false
    end

    it "should be true for a liked movie" do
      @user.like!(@movie)
      @user.likes_movie?(@movie).should be_true
    end
  end

  describe "#like!" do
    it "should return true for a new like" do
      @user.like!(@movie).should be_true
    end

    it "should return false for an already liked movie" do
      @user.like!(@movie)
      @user.like!(@movie).should be_false
    end
  end

  describe "#unlike!" do
    it "should return true for an old like" do
      @user.like!(@movie)
      @user.unlike!(@movie).should be_true
    end

    it "should return false for a non liked movie" do
      @user.unlike!(@movie).should be_false
    end
  end

  describe "#destroy" do
    it "should cleanup movie likes for a deleted user" do
      @user.like!(@movie)
      @user.liked_movies_count.should eq(1)
      @movie.likes.should eq(1)
      @user.destroy
      @user.liked_movies_count.should eq(0)
      @movie.likes.should eq(0)
    end
  end
end