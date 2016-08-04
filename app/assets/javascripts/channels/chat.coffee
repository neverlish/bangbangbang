step = "day"

App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    this.user_join()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

    if data.step?.length
      step = data.step

     if data.message?
        appendMessage(data.message)
        $("#night-messages").scrollTop($("#night-messages")[0].scrollHeight)
        $("#day-messages").scrollTop($("#day-messages")[0].scrollHeight)

    if data.system_info?
      if data.system_info == "user_join"
        appendSystemAnounce(data.user_info.name + "님이 참여하셨습니다.")

      else if data.system_info == "players_lists"
        $('#chatting-info-items').html('') #보내기전에 내용 전부다 지우기  
        for player in data.players
          appendSystemUserListItem(player)
        appendSystemMessage(data.count_number)

      else if data.system_info == "game_started"
        appendSystemAnounce("Mafia Game 이 시작되었습니다.")

      else if data.system_info == "player_dead"
        appendSystemAnounce(data.player_name + "이 사망했습니다.")

      else if data.system_info == "game_end"
        appendSystemAnounce("<<게임 끝>>" + data.result + "승리")

    if data.system_info?
      if data.system_info == "user_join"
        appendSystemMessage(data.user_info.count_number)
   
  speak: (msg) ->
    @perform 'speak', message: msg

  talk: (msg) ->
    @perform 'speak', message: msg

  change_step: (step) ->
    @perform 'change_step', step: step

  kill_player: (kill_number) ->
   @perform 'kill_player', kill_number: kill_number

  start_game: ->
    @perform 'start_game'

  user_join: ->
    @perform 'user_join'

  appendMessage = (message) ->
    if step == "day"
      $('#day-messages').append(message)

    else if step == "night"
      $('#night-messages').append(message)

  appendSystemMessage = (message) ->
    $('#info-messages').html(message)


#sytem info mation temporal functions 

 appendSystemAnounce = (message) ->
    if step == "day"
      $('#day-messages').append(message + '<br>')

    else if step == "night"
      $('#night-messages').append(message + '<br>')

#sytem info mation disaply (user list)

  appendSystemUserListItem = (userListItem) ->
    itemHtmlString = 
      '<div>' + userListItem.index + ' ' + userListItem.name + ' [' + userListItem.status + ']' +
      '</div>'

    $('#chatting-info-items').append(itemHtmlString)

  appendSystemMessageUserIndex = (message) ->
    $('#user-info-index').append(message + '<br>')

  appendSystemMessageUserName = (message) ->
    $('#user-info-name').append(message + '<br>')

  appendSystemMessageUserStat = (message) ->
    $('#user-info-status').append(message + '<br>')


$(document).on 'keypress', '#chat-speak', (event) ->
  if event.keyCode is 13
    App.chat.speak(event.target.value)
    event.target.value = ""
    event.preventDefault()

$(document).on 'keypress', '#chat-talk', (event) ->
  if event.keyCode is 13
    App.chat.talk(event.target.value)
    event.target.value = ""
    event.preventDefault()

$(document).on 'click', '#night', ->
  App.chat.change_step("night")
  $('#input_day').toggle()

$(document).on 'click', '#day', ->
  App.chat.change_step("day")
  $('#input_night').toggle()

$(document).on 'click', '#start_game', ->
  App.chat.start_game()
  $('#start_game').toggle()

$(document).ready ->
  $('')


$(document).on 'click', '#player1', ->
 App.chat.kill_player("0")
$(document).on 'click', '#player2', ->
 App.chat.kill_player("1")
$(document).on 'click', '#player3', ->
 App.chat.kill_player("2")
$(document).on 'click', '#player4', ->
 App.chat.kill_player("3")
$(document).on 'click', '#player5', ->
 App.chat.kill_player("4")
$(document).on 'click', '#player6', ->
 App.chat.kill_player("5")
$(document).on 'click', '#player7', ->
 App.chat.kill_player("6")
$(document).on 'click', '#player8', ->
 App.chat.kill_player("7")
$(document).on 'click', '#player9', ->
 App.chat.kill_player("8")
$(document).on 'click', '#player10', ->
 App.chat.kill_player("9")