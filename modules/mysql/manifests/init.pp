class mysql {
	package { 'mysql-server':
		ensure => present,
	}

	service { 'mysqld':
		enable => true,
		ensure => running,
		require => Package['mysql-server'],
	}
}
