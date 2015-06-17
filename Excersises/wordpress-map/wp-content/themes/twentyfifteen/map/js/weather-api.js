function getWeatherData() {
	listWeatherTable()
		.then(function (data) {
			populateSelectOptions($("select"), data, "name", false);
			initMap(data);
		})
		.fail(function (data) {
			console.log('weather request failed');
			console.log(data);
		});
}
