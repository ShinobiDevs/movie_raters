class UsersController < ApplicationController

  respond_to :json, :xml

  # GET /users.json
  # GET /users.xml
  def index
    @users = User.all
    respond_with(@users)
  end

  # GET /users/1.json
  # GET /users/1.xml 
  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  # POST /users.json
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.save
    respond_with(@user)
  end

  # PUT /users/1.json
  # PUT /users/1.xml 
  def update
    @user = User.find(params[:id])
    @user.update_attribute(params[:user])
    respond_with(@user)
  end

  # DELETE /users/1.json
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render nothing: true, status: 200
  end
end
