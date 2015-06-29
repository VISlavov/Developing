<?php
/**
 * The template for displaying 404 pages (not found)
 *
 * @package WordPress
 * @subpackage Twenty_Fifteen
 * @since Twenty Fifteen 1.0
 */

get_header(); ?>

	<div id="primary" class="content-area">
		<main id="main" class="site-main" role="main">
			<h2>
				Map
			</h2>
		
			<?php include('map/map.php') ?>

			<?php
				function setUserData() {
					$servername = "localhost";
					$username = "wp";
					$password = "pass";
					$dbname = "wp";

					$conn = new mysqli($servername, $username, $password, $dbname);

					if ($conn->connect_error) {
						echo "Connection failed: " . $conn->connect_error;
						return -1;
					}

					$sql = "SELECT * FROM wp_weather_stations";
					$result = $conn->query($sql);
					$data = array();

					while($row = $result->fetch_assoc()) {
						array_push($data, json_encode($row)); 
					}

					$data = implode(",", $data);
					$data = "[" . $data . "]";

					echo 
					"<script type='text/javascript'>
						var weatherData = ${data};
						initWeatherData(weatherData);
					</script>";

					$conn->close();
				}
			?>
			
			<?php
				setUserData();
			?>

		</main><!-- .site-main -->
	</div><!-- .content-area -->

<?php get_footer(); ?>
