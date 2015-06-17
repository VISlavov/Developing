<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		
		<title>Simple Map</title>
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta charset="utf-8" />
		<!-- Add styles for width and height -->
		<style>
			#map-canvas {
				height: 450px;
				width: 800px;
			}
		</style>

		<link rel="stylesheet" type="text/css" href="/wp-content/themes/twentyfifteen/map/css/map.css">
	</head>
	<body>

		<button id="prev">Prev</button>
		<button id="next">Next</button>
		<select></select>
		<div class="loader"></div>
		<div id="map-canvas"></div>

		<script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/infobox/src/infobox.js"></script>
		<script type="text/javascript" src="https://raw.githubusercontent.com/andrewplummer/Sugar/master/release/sugar.min.js"> </script>
		<script type="text/javascript" src="https://raw.githubusercontent.com/noazark/weather/master/weather.js"> </script>
		<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/vendor/q/q.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/vendor/jq.min.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/weather-api.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/gmap-api.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/db-api.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/util.js"> </script>
		<script type="text/javascript" src="/wp-content/themes/twentyfifteen/map/js/map.js"> </script>
	</body>
</html>

