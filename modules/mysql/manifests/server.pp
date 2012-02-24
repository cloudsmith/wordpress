class mysql::server {
	include mysql::client

	$mysql_server = $::operatingsystem ? {
		Ubuntu => 'mysql-server',
		CentOS => 'mysql-server',
		Debian => 'mysql-server',
		default => 'mysql-server',
	}

	$mysql_service = $::operatingsystem ? {
		Ubuntu => 'mysql',
		CentOS => 'mysqld',
		Debian => 'mysql',
		default => 'mysqld',
	}

	package { "${mysql_server}":
		ensure => latest,
	}

	service { 'mysql-service':
		name => "${mysql_service}",
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package["${mysql_server}", 'mysql-client'],
	}
}
