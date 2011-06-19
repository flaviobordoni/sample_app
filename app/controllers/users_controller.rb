class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Signup"
  end

  def create
    #raise params[:user].inspect
    @user = User.new(params[:user])
    if @user.save
      #tratto utente salvato
      sign_in @user
      redirect_to user_path(@user.id),
                  :flash => { :success => "Welcome to the sample app! ciao"}
    else
      # mostro errori con partial shared/error_messages
      @title = "Signup"
      render "new"
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
end
