angular.module('app.controllers.reports', [])
  .controller 'Reports', ['$scope', '$location', 'Report', 'Identity', ($scope, $location, Report, Identity) ->
    $scope.currentUser = Identity.currentUser
    $scope.reports = Report.query()
    $scope.order = "title";
    $scope.delete = (idx, id) ->
      success = ->
        $scope.reports.splice(idx, 1)
      failure = ->
        alert 'some error occurred. check your logs'

      new Report().$delete({id: id}, success, failure)
  ]
  .controller 'NewReport', ['$scope', '$location', 'Report', 'Category', ($scope, $location, Report, Category) ->
    $scope.categories = Category.query()
    $scope.report =
      title: ''
      description: ''
      category_id: ''

    $scope.submit = ->
      $scope.errors = null

      success = ->
        $scope.report = {}

        $location.path('#/')

      failure = (resp) ->
        $scope.errors = resp.data.errors


      new Report({report: $scope.report}).$save({}, success, failure)
  ]
  .controller 'EditReport', ['$scope', '$location', '$routeParams', 'Report', 'Category',  ($scope, $location, $routeParams, Report, Category) ->
    $scope.categories = Category.query()
    $scope.report = Report.get({id: $routeParams.id})

    $scope.submit = ->
      $scope.errors = null

      success = ->
        $scope.report = {}

        $location.path('#/')

      failure = (resp) ->
        $scope.errors = resp.data.errors

      new Report({report: $scope.report}).$update({id: $routeParams.id}, success, failure)
  ]
  .controller 'ShowReport', ['$scope', '$location', '$routeParams', 'Report', 'Comment', ($scope, $location, $routeParams, Report, Comment) ->
    $scope.report = Report.get({id: $routeParams.id})
    $scope.comments = Comment.get({report_id: $routeParams.id})
    $scope.new_comment =
      text: ''

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

    $scope.delete = (id) ->
      success = ->
        $location.path('#/')
      failure = ->
        alert 'some error occurred. check your logs'

      new Report().$delete({id: id}, success, failure)
  ]