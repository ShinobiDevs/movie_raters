class LikesController < ApplicationController

  before_filter :find_user_and_movie, only: [:create, :destroy]
  # GET /users/1/likes.json
  # GET /users/1/likes.xml
  def index
    @user = User.where(id: params[:user_id]).first
    respond_to do |wants|
      if @user.present?
        response_hash = {likes: @user.liked_movies_ids }
        wants.xml { render xml: response_hash }
        wants.json { render json: response_hash }
      else
        wants.xml { render nothing: true, status: :not_found }
        wants.json { render nothing: true, status: :not_found }
      end
    end
  end

  def create
    if @user.like!(@movie)
      render nothing: true, status: :created
    else
      render nothing: true, status: :not_modified
    end
  end

  def destroy
    if @user.unlike!(@movie)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :not_modified
    end
  end

  protected

  def find_user_and_movie
    @user = User.where(id: params[:user_id]).first
    @movie = Movie.where(id: params[:id]).first if params.has_key?(:id)

    if @user.blank? || (@movie.blank? && params.has_key?(:id))
      render nothing: true, status: :not_found
      return
    end
  end
end
