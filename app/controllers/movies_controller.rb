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
    @movie = Movie.find(params[:id])
    respond_with(@movie)
  end

  # POST /movies.json
  # POST /movies.xml
  def create
    @movie = Movie.new(params[:movie])
    @movie.save
    respond_with(@movie)
  end

  # PUT /movies/1.json
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])
    @movie.update_attributes(params[:movie])
    respond_with(@movie)
  end

  # DELETE /movies/1.json
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    render nothing: true, status: 200
  end
end
