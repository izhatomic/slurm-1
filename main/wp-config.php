<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'mysite_db' );

/** Database username */
define( 'DB_USER', 'wp_user' );

/** Database password */
define( 'DB_PASSWORD', 'password123' );

/** Database hostname */
define( 'DB_HOST', 'db:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '=_s2Wcp+5@.^p PjohsA[2aqM xK~Aq;nyT_$C:NS()x},q3JhUr{58-Tvhf`_Ny' );
define( 'SECURE_AUTH_KEY',  'k2I6(ptmNcomclDVZgi%w!=o[g+S@2uZ=uHt[|ax4xA<EoJF)eW{M1[j$-,X`N:=' );
define( 'LOGGED_IN_KEY',    't81^ti|@L!)n~XR&8=u/p$7.t[/[[WUM6T#-UmUXW^oua.so?MDoFZDI_3giD4<7' );
define( 'NONCE_KEY',        'S.2WSMw[hgFB$L!:S@3KIF#7GBpx[nY7%+sC4W@g/B[`R;$2;E6,=c9<Eb+Ud6<T' );
define( 'AUTH_SALT',        'yNC{dQ`jj@pr5Yjq&GM*zVQzF%q1wd_RZJAK)&K;?L?.;d$ ]43:yrbi/1spLSnT' );
define( 'SECURE_AUTH_SALT', 'l4N 4n@([HF-cJ(^R^w#O,6;6r.j=fE)USiq#btm43#JONjI9Qs:8kD:i!Wg1g%Q' );
define( 'LOGGED_IN_SALT',   '-/Uxm zicD!C0eiwv1#Ug4rO`x}48S_Ns~x?Qyr7PLi>b[X?KKI^hd@R`0dt /I:' );
define( 'NONCE_SALT',       'W[6}:yt$CubO+s,l~n~=$7i0f4kVy:Id^EFW|5jFjo2V0$7ac<-Tm)L(@F?>8sbn' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */

$_SERVER['HTTPS'] = 'on';
define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

