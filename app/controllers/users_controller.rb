class UsersController < ApplicationController

  def new
    @title = "Signup"
  end
  
  def show
    @user = User.find(params[:id])
  end
end
