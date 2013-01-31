class UsersController < ApplicationController
    before_filter :signed_in_user, only: [:show, :new]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

      if @user.save
        flash[:notice] = 'User was successfully created.'
        redirect_to users_path
      else
        render action: "new"
      end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if @user.user_name != 'admin' && @user != current_user 
        @user.destroy
    end

    redirect_to users_url
  end


end
