app.controller("DatePickerController", function ($scope, SettingsData){
	$scope.dateFormat = SettingsData.dateFormat;
	$scope.isDatePickerOpen = false;
	$scope.switchDatePickerState = function () {
		$scope.isDatePickerOpen = !$scope.isDatePickerOpen;
	};
});
