class mysql::client {
	$mysql_client = $::operatingsystem ? {
		Ubuntu => 'mysql-client',
		CentOS => 'mysql',
		Debian => 'mysql-client',
		default => 'mysql',
	}

	package { 'mysql-client':
		name => "${mysql_client}",
		ensure => latest,
	}
}
