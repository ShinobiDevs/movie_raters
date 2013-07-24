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
    @user = User.where(id: params.require(:id)).first
    if @user.present?
      respond_with(@user)
    else
      render nothing: true, status: :not_found
    end
  end

  # POST /users.json
  # POST /users.xml
  def create
    @user = User.new(params.require(:user).permit(:email, :name))
    @user.save
    respond_with(@user)
  end

  # PUT /users/1.json
  # PUT /users/1.xml 
  def update
    @user = User.where(id: params[:id]).first
    if @user.blank?
      render nothing: true, status: :not_found
    else
      @user.update_attributes(params.require(:user).permit(:email, :name))
      respond_with(@user)
    end
  end

  # DELETE /users/1.json
  # DELETE /users/1.xml
  def destroy
    @user = User.where(id: params[:id]).first
    if @user.blank?
      render nothing: true, status: :not_found
    else
      @user.destroy
      render nothing: true, status: :ok
    end
  end
end
