var displayController = new DataDisplayController(),
	requestController = new DataRequestController(displayController),
	service = new MainService(displayController);

displayController.prepareDisplay();

$('#data-request-button').click(function() {
	//Evasion for concurrent requests
	if(service.checkRequestConcurrency()) {
		return;
	}

	var desiredDataCount = service.getDesiredDataCount();

	if(service.isDataCountValid(desiredDataCount)) {
		displayController.clearOldData();

		requestController.getDataCollection(desiredDataCount)
			.then(function(data) {
				displayController.displayLoadedData(data);
			});
	}

});

