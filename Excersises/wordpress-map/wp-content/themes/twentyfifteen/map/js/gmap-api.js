function initMap(weatherData) {
	var map,
		z = 4,
		i = 0,
		stations = weatherData;

	function hideFromBugger() {
		if(i == 0) {
			$('#prev').hide();
			$('#next').show();
		} else if(i == stations.length - 1)	{
			$('#next').hide();
			$('#prev').show();
		} else {
			$('#next').show();
			$('#prev').show();
		}
	}

	function setMarkers() {
		var label,
			pos;

		for(i in stations) {
			pos = getPosForStation(i);
			label = getLabelForStation(i);

			new google.maps.Marker({
					position: pos,
					map: map,
					title: label
			});
		}
	}

	function getPosForStation(i) {
		var pos = new google.maps.LatLng(stations[i].lat, stations[i].lon);

		return pos;
	}

	function getLabelForStation(i) {
		var label = stations[i].name + " / " + "temperature: " + stations[i].temperature;

		return label;
	}
	
	function setPosition() {
		var pos = getPosForStation(i);

		map.panTo(pos);
	}
	
	$('select').change(function () {
		i = $(this).get(0).selectedIndex;
		setPosition();
		hideFromBugger();
	});
	
	function initialize() {
		var mapOptions = {
				zoom: z,
				center: getPosForStation(0),
				mapTypeId: google.maps.MapTypeId.ROADMAP //SATELLITE
			};

		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
			
		setMarkers();
		hideFromBugger();
	}

	document.getElementById('next').addEventListener('click', function () {
		$('select').get(0).selectedIndex = i + 1;
		$('select').change();
	}, false);
	
	document.getElementById('prev').addEventListener('click', function () {				
		$('select').get(0).selectedIndex = i - 1;
		$('select').change();
	}, false);

	google.maps.event.addDomListener(window, 'load', initialize());
}
