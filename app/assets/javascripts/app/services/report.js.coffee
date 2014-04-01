angular.module 'app.services', [], ($provide) ->
  $provide.factory 'Report', ($resource) ->
    $resource '/reports/:id', {id: '@id'}, {update: {method: 'PUT'}}
