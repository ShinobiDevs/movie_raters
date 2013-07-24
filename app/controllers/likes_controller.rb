class LikesController < ApplicationController

  before_filter :find_user_and_movie, only: [:create, :destroy]
  # GET /users/1/likes.json
  # GET /users/1/likes.xml
  def index
    @user = User.find(params[:user_id])
    respond_to do |wants|
      if @user.present?
        response_hash = {likes: @user.liked_movies_ids }
        wants.xml { render xml: response_hash }
        wants.json { render json: response_hash }
      else
        wants.xml { render nothing: true, status: :not_found}
        wants.json { render nothing: true, status: :not_found }
      end
    end
  end

  def create 
    @user.like!(@movie)
    render nothing: true, status: :created
  end

  def destroy
    @user.unlike!(@movie)
    render nothing: true, status: :ok
  end

  protected

  def find_user_and_movie
    @user = User.find(params[:user_id])
    @movie = Movie.find(params[:movie_id])

    if @user.blank? || @movie.blank?
      render nothing: true, status: :not_found
      return
    end
  end
end
