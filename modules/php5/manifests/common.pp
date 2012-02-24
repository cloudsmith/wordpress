class php5::common {
	$php_common = $::operatingsystem ? {
		Ubuntu => 'php5-common',
		CentOS => 'php-common',
		Debian => 'php5-common',
		default => 'php-common',
	}

	package { 'php5-common':
		name => "${php_common}",
		ensure => latest,
	}
}
