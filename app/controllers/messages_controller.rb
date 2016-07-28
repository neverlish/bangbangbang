# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def index
  	if Mapium.where(game_id: Game.last.id).size == 1
  		Game.last.update(master_id: current_user.id, status: "ready")
  	end
  	# @online_list = []
   #  unless @online_list.include? current_user.email
   #  	@online_list << current_user.email
   #  end
  end
end