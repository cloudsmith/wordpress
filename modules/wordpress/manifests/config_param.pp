define wordpress::config_param($wp_root, $key, $value) {
	include internal::lens

	# first try to see if there is a double quoted param of the specified name
	# and if it is then replace it with a single quoted version and set it to the desired value
	augeas { "wp_replace_double_quoted_config_param-${wp_root}-${key}":
		incl => "${wp_root}/wp-config.php",
		lens => 'Wordpress.lns',
		context => "/files${wp_root}/wp-config.php",
		onlyif => "match \"\\\"${key}\\\"\" != []",
		changes => [
			"insert \"'${key}'\" after \"\\\"${key}\\\"\"",
			"remove \"\\\"${key}\\\"\"",
			"set \"'${key}'\" \"'${value}'\"",
		],
		require => [Augeas::Lens['wordpress'], File["${wp_root}/wp-config.php"]],
	}

	# if the parameter is not there yet, then insert it just before the footer
	augeas { "wp_insert_new_config_param-${wp_root}-${key}":
		incl => "${wp_root}/wp-config.php",
		lens => 'Wordpress.lns',
		context => "/files${wp_root}/wp-config.php",
		onlyif => "match \"'${key}'\" == []",
		changes => [
			"insert \"'${key}'\" before \"footer\"",
			"set \"'${key}'\" \"'${value}'\"",
		],
		require => Augeas["wp_replace_double_quoted_config_param-${wp_root}-${key}"],
	}

	# else just set its value
	augeas { "wp_set_config_param-${wp_root}-${key}":
		incl => "${wp_root}/wp-config.php",
		lens => 'Wordpress.lns',
		context => "/files${wp_root}/wp-config.php",
		changes => [
			"set \"'${key}'\" \"'${value}'\"",
		],
		require => Augeas["wp_insert_new_config_param-${wp_root}-${key}"],
	}
}
