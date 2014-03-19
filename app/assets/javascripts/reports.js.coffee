# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'click', 'button#fb-share', (e) ->
    redirect_uri = $(this).attr("data-redirect_uri")
    link = $(this).attr("data-link")
    picture = $(this).attr("data-picture")
    name = $(this).attr("data-name")
    caption = $(this).attr("data-caption")
    description = $(this).attr("data-description")


    obj =
      method: 'feed',
      redirect_uri: redirect_uri,
      link: link,
      picture: picture,
      name: name,
      caption: caption,
      description: description

    FB.ui obj

  $(document).on 'click', 'button#fb-send-link', (e) ->
    link = $(this).attr("data-link")
    obj =
      method: 'send',
      #link: link
      link: "http://lannisport-rails-93377.euw1-2.nitrousbox.com/"
      
    FB.ui obj


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





