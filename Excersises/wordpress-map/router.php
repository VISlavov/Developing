<?php

$f = fopen('php://stdout', 'w');

foreach ($_SERVER as $name => $value) {
    fputs($f, "-------------------");
    fputs($f, "$name: $value\n");
}

?>
