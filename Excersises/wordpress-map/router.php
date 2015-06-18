<?php

$f = fopen('php://stdout', 'w');

foreach ($_SERVER as $name => $value) {
    fputs($f, "-------------------");
    fputs($f, "$name: $value\n");
}

$cookie_key = 'HTTP_COOKIE';

if(array_key_exists($cookie_key, $_SERVER)) {
	$myfile = fopen("/home/vicky/Dropbox/what-the/Dev/Excersises/wordpress-map/wp-content/themes/twentyfifteen/map/js/rhino/cookie", "w");
	if($myfile == false) {
    fputs($f, "File failed to open.");
	}
	fwrite($myfile, $_SERVER[$cookie_key]);
	fclose($myfile);
}

return false;

?>
