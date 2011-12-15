class wordpress::internal::prerequisites {
	include php5
	include mysql
	include augeas

	package { ['curl', 'tar', 'php-mysql']:
		ensure => present,
	}
}
