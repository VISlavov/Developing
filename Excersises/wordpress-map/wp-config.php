<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, and ABSPATH. You can find more information by visiting
 * {@link https://codex.wordpress.org/Editing_wp-config.php Editing wp-config.php}
 * Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wp');

/** MySQL database username */
define('DB_USER', 'wp');

/** MySQL database password */
define('DB_PASSWORD', 'pass');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'VDAZ0Nu__P`ppXhgo+T|$9T+nU{}=B;4 be?5I6OS9L>s&6C6:E`3,(5l2s=!}jR');
define('SECURE_AUTH_KEY',  '}=YlaO/ciJx#TQw7*66f+Oea*-X;YpNuAYtJa!] 0l~|LeDmlBO^+;+p.RRC_E8c');
define('LOGGED_IN_KEY',    '@~^Q`<!Lwq#<GJ}A/-2!L.F^sGa-!%+-HguYE2VA@ !2nW22rGCB<mtyvOz92t=3');
define('NONCE_KEY',        'p5&o4 R?S`Vl`{+:|BR.mj6a#ds*=xV(@^mv_c4>0#[FVa! DEXhHIIhKk}]{bfv');
define('AUTH_SALT',        'mCo$1wjM7XyDB+eqDAQcYOFg1v4GCqAuta79@h--]^&YE+VuT)>15Qy9P2!uUcLK');
define('SECURE_AUTH_SALT', 'Sjna@ZJ,iG|-M/Kqmpq=Tt+j:ew+!q#$CQ.GgL_{FS$+@2/(h93vBP+#yv%EZ G-');
define('LOGGED_IN_SALT',   'z&%yiM7)y$SafIRk^/!pg%2p+vIzE[z;%k:,KK$W>KU;_qN$kW6WfX1:EuQM,*`@');
define('NONCE_SALT',       'i<C%HDx$;HS+JKA-F(dPo{6IRL~5X):ne JY6-I5c4;E yi/b` bw[_F2]bX,-%/');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
