angular.module('app.controllers.login', [])
  .controller 'Login', ['$scope', '$location', "$http", "Identity", ($scope, $location, $http, Identity) ->

    $scope.currentUser = Identity.currentUser
    $scope.signin = (username, password) ->
      $http.post('../users/sign_in.json', {user: {email: $scope.username, password: $scope.password}})
      .then (response)->
        Identity.currentUser = response.data
        $scope.currentUser = response.data
        $scope.username = "" 
        $scope.password = ""
        $location.path('#/')

    $scope.signout = ->
      $http({method: 'DELETE', url: '../users/sign_out', data: {}})
      .then (response)->
        $scope.currentUser = null
        $scope.current_user = null
        Identity.currentUser = null
        $location.path('#/')
  ]
  