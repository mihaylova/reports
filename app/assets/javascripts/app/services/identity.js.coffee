angular.module 'app.services.identity', [], ($provide) ->
  $provide.factory 'Identity', () ->
    currentUser = null
    currentUser: currentUser
