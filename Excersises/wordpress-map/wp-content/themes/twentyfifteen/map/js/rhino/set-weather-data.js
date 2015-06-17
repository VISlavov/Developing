var wphost = 'http://127.0.0.1:8088',
	setTimeout,
	clearTimeout,
	setInterval,
	clearInterval;

(function () {
	var timer = new java.util.Timer();
	var counter = 1; 
	var ids = {};

	setTimeout = function (fn,delay) {
		var id = counter++;
		ids[id] = new JavaAdapter(java.util.TimerTask,{run: fn});
		timer.schedule(ids[id],delay);
		return id;
	}

	clearTimeout = function (id) {
		ids[id].cancel();
		timer.purge();
		delete ids[id];
	}

	setInterval = function (fn,delay) {
		var id = counter++; 
		ids[id] = new JavaAdapter(java.util.TimerTask,{run: fn});
		timer.schedule(ids[id],delay,delay);
		return id;
	}

	clearInterval = clearTimeout;
})();

/*setTimeout(function () {
	setWPHeaders();
}, 1000);
*/

function setWPHeaders() {
	$.ajax({
		url: wphost,
	})
	.done(function (data) {
		var $doc = $.parseHTML(data),
			cookieHolder = $('#cookie-holder', $doc),
			cookie = cookieHolder.attr('data-cookie');

		console.log(data);
		console.log(cookie);

		$.ajaxSetup({
			headers: { 'Cookie':  cookie},
		});
	})
	.fail(function (err) {
		console.log('cookie request fail');
	});
}

function setWeatherData() {
	var upperBoundary = {
			lat: "83",
			lon: "-165",
		},
		lowerBoundary  = {
			lat: "-81",
			lon: "-40",
		},
		weatherMapZoom = 15,
		weatherAPIKey = "711891b85effcf99e344ade54a7eedb7",
		getStationsUrl = "http://api.openweathermap.org/data/2.5/box/city?cluster=yes&bbox=" +
			upperBoundary.lat +
			"," +
			upperBoundary.lon +
			"," +
			lowerBoundary.lat +
			"," +
			lowerBoundary.lon +
			"," +
			weatherMapZoom;

	$.ajax({
		url: getStationsUrl,
	})
	.done(function (data) {
		addAllWeatherDataToDb(data);
	})
	.fail(function (data) {
		console.log('weather request failed');
	})
}

function deleteWeatherTableMetaCells(table) {
	$(table.find('tr')[0]).remove();

	table.find('tr').each(function(){
		$($(this).find('td')[0]).remove();
	});

	return table;
}

function getRowContentsSpecifiers(table) {
	var heading = $(table.find('tr')[0]),
		headingTitle = '',
		rowSpec = [];
	
	$(heading.find('th')[0]).remove();
	
	heading.find('th').each(function () {
		headingTitle = $(this).find('a > span:first-child').text();
		rowSpec.push(headingTitle);
	});

	return rowSpec;
}

function parseWeatherTableHtml(data) {
	var $doc = $.parseHTML(data),
		table = $('table', $doc),
		rowSpec = getRowContentsSpecifiers(table),
		jsonTable = [],
		headingIndex = 0,
		rowIndex = 0,
		rowData = {};
	
	table = deleteWeatherTableMetaCells(table);
	
	table.find('tr').each(function(){
		$(this).find('td').each(function(){
			rowData[rowSpec[headingIndex]] = $(this).text();	
			headingIndex++;
		})

		jsonTable[rowIndex] = rowData;
		rowIndex++;
		headingIndex = 0
		rowData = {};
	});


	return jsonTable;	
}

function listWeatherTable() {
	var url = wphost + "/wp-admin/admin.php?page=simple_table_manager_list",
		tableJson = {},
		deferred = Q.defer();

	$.ajax({
		method: "GET",
		url: url,
		data: {
			page: 'simple_table_manager_list',
		}
	})
	.done(function (data) {
		jsonTable = parseWeatherTableHtml(data);
		deferred.resolve(jsonTable);
	})
	.fail(function (data) {
		console.log('weather list request failed');
		deferred.reject();
	});

	return deferred.promise;
}

function lsT() {
	listWeatherTable()
		.then(function (data) {
			console.log(data);
			for(key in data) {
				console.log(key + ' ' + data[key]);
			}
		})
		.fail(function () {
			console.log('fail');
		});
}

function deleteWeatherTableRecord(data) {
	var url = wphost + "/wp-admin/admin.php?page=simple_table_manager_edit",
		id = data.id,
		name = data.name,
		temperature = data.temperature,
		humidity = data.humidity,
		pressure = data.pressure,
		lat = data.lat,
		lon = data.lon;

	$.ajax({
		method: "POST",
		url: url,
		data: {
			page: 'simple_table_manager_edit',
			id: id,
			name: name,
			temperature: temperature,
			humidity: humidity,
			pressure: pressure,
			lat: lat,
			lon: lon,
			"delete": 'delete',
		}
	})
	.fail(function (data) {
		console.log('weather data delete request failed ' + data);
	});
}

function deleteWeatherData() {
	listWeatherTable()
		.then(function (data) {
			$(data).each(function () {
				deleteWeatherTableRecord(this);
			});
		});
}

function addWeatherTableRow(name, temperature, humidity, pressure, lat, lon) {
	var url = wphost + "/wp-admin/admin.php?page=simple_table_manager_edit";

	$.ajax({
		method: "POST",
		url: url,
		data: {
			page: 'simple_table_manager_edit',
			name: name,
			temperature: temperature,
			humidity: humidity,
			pressure: pressure,
			lat: lat,
			lon: lon,
			add: 'Add',	
		}
	})
	.fail(function (data) {
		console.log('weather edit request failed');
	})
}

function addAllWeatherDataToDb(weatherData) {
	deleteWeatherData();
	var result;

	for(var i = 0; i < weatherData.list.length; i++) {
		result = weatherData.list[i];	
		addWeatherTableRow(
			result.name,
			result.main.temp,
			result.main.humidity,
			result.main.pressure,
			result.coord.lat,
			result.coord.lon);
	}
}
