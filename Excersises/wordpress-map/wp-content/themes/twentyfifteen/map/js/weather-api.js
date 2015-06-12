function getWeatherData() {
	var upperBoundary = {
			lat: "82.53",
			lon: "-161.49",
		},
		lowerBoundary  = {
			lat: "-56.21",
			lon: "167.13",
		},
		weatherAPIKey = "711891b85effcf99e344ade54a7eedb7",
		getStationsUrl = "http://api.openweathermap.org/data/2.5/box/city?cluster=yes&format=json&bbox=" +
			upperBoundary.lat +
			", " +
			upperBoundary.lon +
			", " +
			lowerBoundary.lat +
			", " +
			lowerBoundary.lon +
			"&APPID=" +
			weatherAPIKey;


	$.ajax({
		url: getStationsUrl,
	})
	.done(function (data) {
		populateSelectOptions($("select"), data.list, "name", false);
		initMap(data);
	})
	.fail(function (data) {
		console.log('weather request failed');
		console.log(data);
	})
}
