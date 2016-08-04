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

  def kill_player(data)
    kill_number = data['kill_number'].to_i
    ActionCable.server.broadcast('messages', system_info: "player_dead", player_name: Game.last.mapia[kill_number].user.name)
    Game.last.mapia[kill_number].update(status:"dead")

    #check triumph condition
    if Game.last.mapia.where(role:"mapia", status:"alive").size == 0
      render_gameEndMesseage("citzen")
    elsif Game.last.mapia.where(role:"citizen",status:"alive") <=Game.last.mapia.where(role:"mapia",status:"alive")
      render_gameEndMesseage("mafia")
    else
      render_userListInfomessage()
    end


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
    count_mapium = Game.last.mapia.size
    if count_mapium >= 5
      Game.last.mapia.all.shuffle.each_with_index do |mapium, index|
        if count_mapium == 5 || count_mapium == 6
          index < 2 ? ( mapium.update(role: "mapia") ) : ( mapium.update(role: "citizen") )
        elsif count_mapium == 7
          index < 3 ? ( mapium.update(role: "mapia") ) : ( mapium.update(role: "citizen") )
        end
      end
    end

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
    ActionCable.server.broadcast('messages', players: mapia.each_with_index.map{|mapium, index| { index: index+1, name: mapium.user.name, status: mapium.status }}, system_info: "players_lists")
  end

  def render_gameEndMesseage(result)
    Game.last.update(result: result)
    ActionCable.server.broadcast('messages', result: result, system_info: "game_end")
   end

end
