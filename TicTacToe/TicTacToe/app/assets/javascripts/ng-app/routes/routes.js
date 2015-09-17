function mainRoutes($routeProvider, $locationProvider){
  var partialsRootUrl = '/templates/';

  $routeProvider
    .when('/', {
			templateUrl: partialsRootUrl + 'home',
      controller: 'HomeController'
    })
    .when('/leaderboard', {
			templateUrl: partialsRootUrl + 'leaderboard',
      controller: 'LeaderboardController'
    })
		.otherwise({ redirectTo: '/' });

	$locationProvider.html5Mode({
			enabled: true,
			requireBase: false
		});
}
