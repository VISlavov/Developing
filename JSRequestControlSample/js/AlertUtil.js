var AlertUtil = function () {
	this.alertInvalidData = function() {
		this.showAlert("Your data is invalid. Plase enter numbers.");
	};

	this.alertNumberOutOfRange = function() {
		this.showAlert("Please enter a positive number, below 1000. ( 0 < number < 1000 )");
	};

	this.showAlert = function(message) {
		alert(message);
	};
};
