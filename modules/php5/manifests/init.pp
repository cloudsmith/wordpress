class php5 {
	include apache2

	package { ['php', 'php-cli']:
		ensure => present,
	}
}
