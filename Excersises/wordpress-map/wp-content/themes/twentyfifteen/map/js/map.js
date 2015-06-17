//getWeatherData();

$(document).ready(function () {
	$('.loader').hide();
});

$(document).ajaxStart(function () {
	$(".loader").show();
});

$(document).ajaxComplete(function () {
	$(".loader").hide();
});
