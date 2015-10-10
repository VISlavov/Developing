app .controller('MainController', function($scope, SettingsData, $modal, ScopeApplier, RequestUtil) {
	$scope.users = [];
	RequestUtil.getUsers($scope);

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
				$scope.updateUser(args.email);
				break;
			default:
				break;
		}
	});

	$scope.addNewUser = function(email) {
		return RequestUtil.getUser($scope, email);
	};

	$scope.removeUser = function(email) {
		var filteredUsers = $scope.users.filter(function (user) {
				return user.email != email;
			});

		return ScopeApplier.apply($scope, "users", filteredUsers);
	};

	$scope.updateUser = function(email) {
		removeUser(email);
		addNewUser(email);
	};
});
