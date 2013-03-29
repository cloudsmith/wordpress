class php5::apache_module {
	include php5::common
	include apache2

	$php = $::operatingsystem ? {
		Ubuntu => 'libapache2-mod-php5',
		CentOS => 'php',
		Debian => 'libapache2-mod-php5',
		default => 'php',
	}

	package { 'php5-apache2_module':
		name => "${php}",
		ensure => latest,
		subscribe => Package['php5-common'],
		notify => Service['apache2-service'],
	}

	Service['apache2-service'] <~ Php5::Plugin<| |>
}
