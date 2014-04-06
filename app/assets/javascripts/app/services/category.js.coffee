angular.module 'app.services.category', [], ($provide) ->
  $provide.factory 'Category', ($resource) ->
    $resource '/categories'
