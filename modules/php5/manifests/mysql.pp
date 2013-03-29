class php5::mysql {
	$php_mysql = $::operatingsystem ? {
		Ubuntu => 'php5-mysql',
		CentOS => 'php-mysql',
		Debian => 'php5-mysql',
		default => 'php-mysql',
	}

	php5::plugin { $php_mysql:
	}
}
