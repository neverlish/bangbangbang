class SessionsController < ApplicationController
	
  def create
    # cookies.signed[:username] = params[:session][:username]
    cookies.signed[:username] = current_user.email
    redirect_to messages_path
  end
end