angular.module('app.controllers.comments', [])
  .controller 'Comments', ['$scope', '$location', '$routeParams', 'Comment', ($scope, $location, $routeParams, Comment) ->

    $scope.comments = Comment.get({report_id: $routeParams.id})
    $scope.new_comment =
      text: ''

    $scope.edit_comment = (idx) ->
      $scope.comments[idx].edit_mode = true

    $scope.update_comment = (idx)->
      success = (resp) ->
        $scope.comments[idx].edit_mode = false

      failure = (resp) ->
        $scope.errors = resp.data.errors


      new Comment({comment: $scope.comments[idx]}).$update({report_id: $routeParams.id, id: $scope.comments[idx].id}, success, failure)

    $scope.add_comment = ->
      success = (resp) ->
        $scope.new_comment = {}
        $scope.comments.push resp
        $("#add_comment").removeClass("invisible")
        $('#new-comment').addClass("invisible")

      failure = (resp) ->
        $scope.errors = resp.data.errors


      new Comment({comment: $scope.new_comment}).$save({report_id: $routeParams.id}, success, failure)

    $scope.delete_comment = (idx, id) ->
      success = ->
        $scope.comments.splice(idx, 1)
      failure = ->
        alert 'some error occurred. check your logs'

      new Comment().$delete({report_id: $routeParams.id, id: id}, success, failure)

  ]
  