class apache2 {
	package { 'httpd':
		ensure => present,
	}

	service { 'httpd':
		enable => true,
		ensure => running,
		require => Package['httpd'],
	}
}
