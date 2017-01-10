var displayController = new DataDisplayController(),
	requestController = new DataRequestController(displayController),
	service = new MainService();

displayController.prepareDisplay();

$('#data-request-button').click(function() {
	var desiredDataCount = service.getDesiredDataCount();

	if(service.isDataCountValid(desiredDataCount)) {
		displayController.clearOldData();

		requestController.getDataCollection(desiredDataCount)
			.then(function(data) {
				displayController.displayLoadedData(data);
			});
	}
});

