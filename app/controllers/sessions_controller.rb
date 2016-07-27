class SessionsController < ApplicationController
before_action :authenticate_user!
  def create
    # cookies.signed[:username] = params[:session][:username]
    cookies.signed[:username] = current_user.email
    redirect_to messages_path
  end
end