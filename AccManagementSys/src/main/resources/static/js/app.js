var mainModule = angular.module('AccManagementSys', [])
  .controller('main', function($scope, $http) {

  $http.get('/resource/').success(function(data) {
		$scope.greeting = data;
	})
})
