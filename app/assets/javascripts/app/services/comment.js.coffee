angular.module 'app.services.comment', [], ($provide) ->
  $provide.factory 'Comment', ($resource) ->
    $resource '/reports/:report_id/comments/:id', {id: '@id', report_id: '@report_id'}, {'get': {method: 'GET', isArray: true}, update: {method: 'PUT'}}
