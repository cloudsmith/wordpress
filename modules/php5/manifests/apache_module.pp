class php5::apache_module {
	include php5::common
	include apache2

	$php = $::operatingsystem ? {
		Ubuntu => 'php5',
		CentOS => 'php',
		Debian => 'php5',
		default => 'php',
	}

	package { 'php5-apache_module':
		name => "${php}",
		ensure => latest,
		subscribe => Package['php5-common'],
		notify => Service['apache2-service'],
	}
}
