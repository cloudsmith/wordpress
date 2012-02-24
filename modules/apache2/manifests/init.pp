class apache2 {
	$apache = $::operatingsystem ? {
		Ubuntu => 'apache2',
		CentOS => 'httpd',
		Debian => 'apache2',
		default => 'httpd',
	}

	package { 'apache2':
		name => "${apache}",
		ensure => latest,
	}

	service { 'apache2-service':
		name => "${apache}",
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package['apache2'],
	}
}
