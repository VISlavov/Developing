function getWeatherData() {
	listWeatherTable()
		.then(function (data) {
			weatherData = data;
			initWeatherData(data);
		})
		.fail(function (data) {
			console.log('weather request failed');
			console.log(data);
		});
}

function initWeatherData(data) {
	populateSelectOptions($("select"), data, "name", false);
	initMap(data);
}
