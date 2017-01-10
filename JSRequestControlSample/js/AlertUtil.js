var AlertUtil = function (mainService) {
	this.alertInvalidData = function() {
		this.showAlert("Your data is invalid. Plase enter numbers.");
	};

	this.alertNumberOutOfRange = function() {
		this.showAlert(
			"Please enter a positive number, below " 
			+ mainService.MAX_COUNT_BOUNDARY 
			+ ". ( "
			+ mainService.MIN_COUNT_BOUNDARY
			+ " < number < "
			+ mainService.MAX_COUNT_BOUNDARY
			+ ")");
	};

	this.showAlert = function(message) {
		alert(message);
	};
};
