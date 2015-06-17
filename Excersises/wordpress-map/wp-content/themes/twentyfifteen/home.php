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
				#Create cookie string
				$cookie_string = '';
				foreach($_COOKIE as $k => $v)
					#Assure we are setting the proper string if other cookies are set
					if(preg_match('/(wordpress_test_cookie|wordpress_logged_in_|wp-settings-1|wp-settings-time-1)/', $k))
						$cookie_string .= $k . '=' . urlencode($v) . '; ';

				#Remove stray delimiters
				$cookie_string = trim($cookie_string, '; ');
				$asdf = 123;

				echo "<div id='cookie-holder' data-cookie='${asdf}'>${asdf} </div>";
			?>
		</main><!-- .site-main -->
	</div><!-- .content-area -->

<?php get_footer(); ?>
