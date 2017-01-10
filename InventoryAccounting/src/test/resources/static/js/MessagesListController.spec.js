describe("MessagesListController", function() {
	var $scope,
		SettingsData = {
			messagesList: []
		},
		MessagesUtil = {
			hasMessages: function () {
				return SettingsData.messagesList.length > 0;
			}
		};

	beforeEach((function() {
		module('InventoryAccounting');	
	}));

	beforeEach(inject(function($rootScope, $controller, $injector) {
		$scope = $rootScope.$new();

		createController = function () {
			return $controller('MessagesListController', {
				'$scope': $scope,
				'MessagesUtil': MessagesUtil,
				'ScopeApplier': {},
				'SettingsData': SettingsData,
			});
		};
	}));

	it("message list updates appropriately", function() {
		createController();

		expect($scope.hasMessages()).toBe(false);

		SettingsData.messagesList.push({text: 'Dummy', status: 'danger'});

		expect($scope.hasMessages()).toBe(true);
	});

});
