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
      link: "https://github.com/"
      
    FB.ui obj

