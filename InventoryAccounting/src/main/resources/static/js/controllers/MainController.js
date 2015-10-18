app .controller('MainController', function($scope, SettingsData, $modal, ScopeApplier, RequestUtil) {
	$scope.stocks = [];
	$scope.sortType = 'name';
  $scope.sortReverse = false;
	$scope.searchCriteria = '';

	RequestUtil.getStocks($scope);

	$scope.changeOrder = function (type) {
		$scope.sortType = type;
		$scope.sortReverse = !$scope.sortReverse;
	};

	$scope.hasStocks = function() {
		return (typeof $scope.stocks != 'undefined') &&
					($scope.stocks.length > 0);
	};

	$scope.$on("stocksUpdated", function (event, args) {
		switch(args.manipulationType) {
			case SettingsData.stockManipulationTypes.post:
				$scope.addNewStock(args.name);
				break;
			case SettingsData.stockManipulationTypes.delete:
				$scope.removeStock(args.name);
				break;
			case SettingsData.stockManipulationTypes.put:
				$scope.updateStock(args.name, args.id);
				break;
			default:
				break;
		}
	});

	$scope.addNewStock = function(name) {
		return RequestUtil.getStock($scope, name);
	};

	$scope.removeStock = function(name, id) {
		var filteredStocks = $scope.stocks.filter(function (stock) {
				var isDifferent;

				if(typeof id != 'undefined') {
					isDifferent = (stock.id != id);
				} else {
					isDifferent = (stock.name != name);
				}

				return isDifferent;
			});

		return ScopeApplier.apply($scope, "stocks", filteredStocks);
	};

	$scope.updateStock = function(name, id) {
		$scope.removeStock(name, id);
		$scope.addNewStock(name);
	};
});
