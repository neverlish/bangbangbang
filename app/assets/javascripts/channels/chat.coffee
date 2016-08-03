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

    if data.system_info?
      if data.system_info == "user_join"
        appendMessage(data.user_info.name + "님이 참여하셨습니다.")

     if data.system_info?
      if data.system_info == "user_join"
        appendMessage(data.user_info.count_number + "명")

  speak: (msg) ->
    @perform 'speak', message: msg

  talk: (msg) ->
    @perform 'speak', message: msg

  change_step: (step) ->
    @perform 'change_step', step: step

  user_join: ->
    @perform 'user_join'

  appendMessage = (message) ->
    if step == "day"
      $('#day-messages').append(message)

    else if step == "night"
      $('#night-messages').append(message)


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

$(document).on 'click', '#day', ->
  App.chat.change_step("day")
