class php5::apache_module {
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
	}
}
