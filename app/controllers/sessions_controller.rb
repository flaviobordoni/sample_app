class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end
  
  def create
    @title = "Sign in"
    user = User.authenticate( params[:session][:email],
                              params[:session][:password])
    if user.nil?
      flash.now[:error] = "invalid email/password combination."
      render "new"
    else
      #gestisci successful sign in
    end
  end
  
  def destroy
    
  end
end
