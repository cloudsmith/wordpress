class wordpress::internal::prerequisites {
	include php5::apache_module
	include php5::mysql
	include mysql::server
	include augeas

	package { ['curl', 'tar']:
		ensure => present,
	}
}
