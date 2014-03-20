# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  page_like_callback = (url, html_element) -> 
    console.log "page_like_callback"
    console.log(url)
    console.log(html_element)

  finished_rendering = ->
    console.log "finished rendering plugins"

  comment_callback =  (response) -> 
    console.log "comment_callback"
    console.log response


  message_send_callback = (url) ->
    console.log("message_send_callback")
    console.log(url)


  FB.Event.subscribe('comment.create', comment_callback)
  FB.Event.subscribe('comment.remove', comment_callback)
  FB.Event.subscribe('edge.create', page_like_callback)
  FB.Event.subscribe('xfbml.render', finished_rendering)
  FB.Event.subscribe('message.send', message_send_callback)





