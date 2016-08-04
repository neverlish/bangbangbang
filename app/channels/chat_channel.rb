# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
 def subscribed
    stream_from 'messages'
  end

  def speak(data)
    ActionCable.server.broadcast('messages',
      message: render_message(data['message']))
  end

  def talk(data)
    ActionCable.server.broadcast('messages',
      message: render_message(data['message']))
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def change_step(data)
    step = data['step']
    Game.last.update!(daynight: step)
    ActionCable.server.broadcast('messages', step: step)
  end

  def user_join
    ActionCable.server.broadcast('messages', step: Game.last.daynight, user_info: { name: Mapium.last.user.name, count_number: Mapium.where(game_id: Game.last.id).count}, system_info: "user_join")
    render_userListInfomessage()
  end
  
  def start_game
    # ActionCable.server.broadcast('messages',
    #   message: render_message("game started"),username:"<<INFO>>" )
    ActionCable.server.broadcast('messages', system_info: "game_started")
    Game.last.update(status: "playing")

  end

  private

  # def render_message(message)
  #   ApplicationController.render(partial: 'messages/message',
  #                                locals: { message: message })
  # end
	def render_message(message)
	  ApplicationController.render(
	    partial: 'messages/message',
	    locals: {
	      message: message,
	      username: current_user
	    })
	end

  def render_userListInfomessage()
    mapia = Game.last.mapia
    ActionCable.server.broadcast('messages', players: mapia.each_with_index.map{|mapium, index| { index: index, name: mapium.user.name, status: mapium.status }}, system_info: "players_lists")
  end

end
