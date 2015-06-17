function addWeatherTableRow(name, temperature, humidity, pressure, lat, lon) {
	var url = "/wp-admin/admin.php?page=simple_table_manager_edit";

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
	var $doc = new DOMParser().parseFromString(data, "text/html"),
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
	var url = "/wp-admin/admin.php?page=simple_table_manager_list",
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

function deleteWeatherTableRecord(data) {
	var url = "/wp-admin/admin.php?page=simple_table_manager_edit",
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
