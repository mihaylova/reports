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
  .controller 'NewReport', ['$scope', '$location', 'Report', ($scope, $location, Report) ->
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
  .controller 'EditReport', ['$scope', '$location', '$routeParams', 'Report', ($scope, $location, $routeParams, Report) ->
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
  .controller 'ShowReport', ['$scope', '$location', '$routeParams', 'Report', ($scope, $location, $routeParams, Report) ->
    $scope.report = Report.get({id: $routeParams.id})
    $scope.delete = (id) ->
      success = ->
        $location.path('#/')
      failure = ->
        alert 'some error occurred. check your logs'

      new Report().$delete({id: id}, success, failure)
  ]