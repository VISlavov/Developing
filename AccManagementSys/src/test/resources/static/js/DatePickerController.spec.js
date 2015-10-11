describe("DatePickerController", function() {
	var $scope;

	beforeEach((function() {
		module('AccManagementSys');	
	}));

	beforeEach(inject(function($rootScope, $controller) {
		$scope = $rootScope.$new();
		
		createController = function () {
			return $controller('DatePickerController', {
				'$scope': $scope,
				'SettingsData': {}
			});
		};
	}));

	it("datepicker states change appropriately", function() {
		createController();

		expect($scope.isDatePickerOpen).toBe(false);
		$scope.switchDatePickerState();
		expect($scope.isDatePickerOpen).toBe(true);
	});

});
