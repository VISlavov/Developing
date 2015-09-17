var mainModule = angular
	.module('TTT', [
			'ngRoute',
	]).run(function ($rootScope, $route) {
		$rootScope.views = {
			home : 'leaderboard',
			leaderboard : 'home'
		};

		$('#navigation-button').click(function () {
			var nextView = $rootScope.views[$rootScope.currentView];
			window.location.replace(nextView);
		});

		$rootScope.$on('$routeChangeSuccess', function (e, current, pre) {
			var currentView = window.location.pathname;
			
			if(currentView == '/') {
				currentView = $rootScope.views.leaderboard;
			} else {
				currentView = $rootScope.views.home;
			}

			$rootScope.currentView = currentView;
		});
	});

mainModule
  .controller('HomeController', HomeController);

mainModule
  .controller('LeaderboardController', LeaderboardController);

mainModule
	.config(mainRoutes);

mainModule
	.filter('orderObjectBy', function() {
		return function(items, field, reverse) {
			var sorted = {}, 
				keysSorted = 
					Object.keys(items)
						.sort(function(a, b) {
							return parseInt(items[a]) - parseInt(items[b]);
						});

			if(reverse) {
				keysSorted.reverse();
			}
			
			for(var i = 0; i < keysSorted.length; i++) {
				var key = keysSorted[i],
					record = {};

				record[key] = items[key];
				sorted = angular.extend({}, sorted, record);
			}

			return sorted;
		};
	});
