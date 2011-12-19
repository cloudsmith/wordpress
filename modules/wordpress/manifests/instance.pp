define wordpress::instance($dbname = 'wordpress', $dbuser = 'wpdbuser', $dbpass = 'wpdbpass') {
	include internal::prerequisites

	$instance_alias = "$name"
	$instance_root = "/var/www/wordpress-${instance_alias}"

	file { "${instance_root}":
		ensure => directory,
                owner => root,
                group => root,
		mode => 0755,
		require => Package['httpd'],
	}

	exec { "wp_download-${instance_alias}":
		command => "curl -sS \"http://wordpress.org/latest.tar.gz\" | tar -C \"${instance_root}\" --strip-components=1 --no-same-owner -xzf -",
		path => ['/usr/local/bin', '/bin', '/usr/bin'],
		creates => "${instance_root}/index.php",
		require => [Package['curl', 'tar'], File["${instance_root}"]],
	}

	mysql::db { "$dbname":
		user => "$dbuser",
		password => "$dbpass",
	}

	file { "${instance_root}/wp-config.php":
		ensure => present,
		replace => false,
		source => "${instance_root}/wp-config-sample.php",
		require => Exec["wp_download-${instance_alias}"],
	}

	config_param { "wp_param-DB_NAME-${instance_alias}":
		wp_root => "$instance_root",
		key => 'DB_NAME',
		value => "$dbname",
	}
	config_param { "wp_param-DB_USER-${instance_alias}":
		wp_root => "$instance_root",
		key => 'DB_USER',
		value => "$dbuser",
	}
	config_param { "wp_param-DB_PASSWORD-${instance_alias}":
		wp_root => "$instance_root",
		key => 'DB_PASSWORD',
		value => "$dbpass",
	}

        file { "/etc/httpd/conf.d/wordpress-${instance_alias}.conf":
                ensure => present,
                content => template('wordpress/wordpress.conf.erb'),
                owner => root,
                group => root,
		mode => 0644,
                require => [
			Mysql::Db["$dbname"],
			Config_param["wp_param-DB_NAME-${instance_alias}", "wp_param-DB_USER-${instance_alias}", "wp_param-DB_PASSWORD-${instance_alias}"],
		],
                notify => Service['httpd'],
        }
}
