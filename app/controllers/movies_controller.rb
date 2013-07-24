class MoviesController < ApplicationController

  respond_to :xml, :json

  # GET /movies.json
  # GET /movies.xml
  def index
    @movies = Movie.all
    respond_with(@movies)
  end

  # GET /movies/1.json
  # GET /movies/1.xml
  def show
    @movie = Movie.where(id: params[:id]).first
    if @movie.blank?
      render nothing: true, status: :not_found
    else
      respond_with(@movie)
    end
  end

  # POST /movies.json
  # POST /movies.xml
  def create
    @movie = Movie.new(params.require(:movie).permit(:name, :year, :genres))
    @movie.save
    respond_with(@movie)
  end

  # PUT /movies/1.json
  # PUT /movies/1.xml
  def update
    @movie = Movie.where(id: params[:id]).first
    if @movie.blank?
      render nothing: true, status: :not_found
    else
      @movie.update_attributes(params.require(:movie).permit(:name, :year, :genres))
      respond_with(@movie)
    end
  end

  # DELETE /movies/1.json
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.where(id: params[:id]).first
    if @movie.blank?
      render nothing: true, status: :not_found
    else
      @movie.destroy
      render nothing: true, status: :ok
    end
  end
end
