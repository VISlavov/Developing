app .controller('MainController', function($scope, SettingsData, $modal, ScopeApplier, RequestUtil) {
	$scope.users = [];
	$scope.sortType = 'firstName';
  $scope.sortReverse = false;
	$scope.searchCriteria = '';

	RequestUtil.getUsers($scope);

	$scope.changeOrder = function (type) {
		$scope.sortType = type;
		$scope.sortReverse = !$scope.sortReverse;
	};

	$scope.hasUsers = function() {
		return (typeof $scope.users != 'undefined') &&
					($scope.users.length > 0);
	};

	$scope.$on("usersUpdated", function (event, args) {
		switch(args.manipulationType) {
			case SettingsData.userManipulationTypes.post:
				$scope.addNewUser(args.email);
				break;
			case SettingsData.userManipulationTypes.delete:
				$scope.removeUser(args.email);
				break;
			case SettingsData.userManipulationTypes.put:
				$scope.updateUser(args.email, args.id);
				break;
			default:
				break;
		}
	});

	$scope.addNewUser = function(email) {
		return RequestUtil.getUser($scope, email);
	};

	$scope.removeUser = function(email, id) {
		var filteredUsers = $scope.users.filter(function (user) {
				var isDifferent;

				if(typeof id != 'undefined') {
					isDifferent = (user.id != id);
				} else {
					isDifferent = (user.email != email);
				}

				return isDifferent;
			});

		return ScopeApplier.apply($scope, "users", filteredUsers);
	};

	$scope.updateUser = function(email, id) {
		$scope.removeUser(email, id);
		$scope.addNewUser(email);
	};
});
