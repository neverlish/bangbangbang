class SessionsController < ApplicationController
	before_action :authenticate_user!
  def create
    # cookies.signed[:username] = params[:session][:username]    
  	if Game.where(status: "ready").size == 0
  		Game.create(master_id: 0)
  	end

  	if Mapium.where(user_id: current_user.id).size == 0 
			Mapium.create(user_id: current_user.id, game_id: 1)
		end
    redirect_to messages_path
  end
end