# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  login_event = (response) -> 
    $.ajax
      url: 'http://localhost:3000/facebook_login',
      success: () ->
        window.location.replace("http://localhost:3000/")


  logout_event = (response) -> 
    $.ajax
      url: 'http://localhost:3000//users/sign_out',
      type: 'DELETE',
      success: () ->
        window.location.replace("http://localhost:3000/")


  FB.Event.subscribe('auth.login', login_event)
  FB.Event.subscribe('auth.logout', logout_event)