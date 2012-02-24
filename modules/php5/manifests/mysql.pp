class php5::mysql {
	include php5::common

	$php_mysql = $::operatingsystem ? {
		Ubuntu => 'php5-mysql',
		CentOS => 'php-mysql',
		Debian => 'php5-mysql',
		default => 'php-mysql',
	}

	package { 'php5-mysql':
		name => "${php_mysql}",
		ensure => latest,
		notify => Package['php5-common'],
	}
}
