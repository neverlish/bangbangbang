step = "day"

App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

    if data.step?.length
      step = data.step

    if data.message?
      if step == "day"
        $('#day-messages').append(data.message)

      else if step == "night"
        $('#night-messages').append(data.message)
      

  speak: (msg) ->
    @perform 'speak', message: msg

  talk: (msg) ->
    @perform 'speak', message: msg

  change_step: (step) ->
    @perform 'change_step', step: step

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