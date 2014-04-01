angular.module('app.directives', [])
  .directive 'confirm', ->
    linker = (scope, element, attrs) ->
      msg = attrs.message || 'Are you sure?'

      element.bind 'click', (event) ->
        if window.confirm(msg)
          scope.$eval(clickAction)
    {
      restrict: 'A'
      link: linker
    }