function initWeatherData(data) {
	populateSelectOptions($("select"), data, "name", false);
	initMap(data);
}
