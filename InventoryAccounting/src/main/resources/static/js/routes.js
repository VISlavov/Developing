app.config(function ($routeProvider, $locationProvider) {
	var baseUrl = '/' + app.name + '/';

	$routeProvider
		.when(baseUrl, {
			templateUrl: 'partials/main.html',
			controller: 'MainController'
		})
		.otherwise({ redirectTo: baseUrl });

	$locationProvider
		.html5Mode({
			enabled: true,
			requireBase: false
		});
});
