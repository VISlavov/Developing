var dataController = new DataController();

console.log(dataController);

$('#data-request-button').click(function() {
	var desiredDataCount = $('input#count-field').val();
	desiredDataCount = parseInt(desiredDataCount);

	if(isNaN(desiredDataCount)) {
		alert("Your data is invalid. Plase enter numbers.");
	} else {
		dataController.getDataCollection(desiredDataCount)
			.then(function(data) {
				console.log(data);
			});
	}
});

