class php5::apache_module {
	include php5::common
	include apache2

	$php = $::operatingsystem ? {
		Ubuntu => 'php5-fpm',
		CentOS => 'php',
		Debian => 'php5-fpm',
		default => 'php',
	}

	package { 'php5-apache2_module':
		name => "${php}",
		ensure => latest,
		subscribe => Package['php5-common'],
		notify => Service['apache2-service'],
	}

	case $::operatingsystem {
		'debian', 'ubuntu': {
			$php_handler = 'php5-fcgi'

			file { '/etc/apache2/mods-enabled/php5-fpm-fcgi.conf':
				ensure => present,
				source => 'puppet:///modules/php5/php5-fpm-fcgi.conf',
				owner => 'root',
				group => 'root',
				mode => '0644',
				require => Package['apache2'],
				notify => Service['apache2-service'],
			}

			exec { 'add-multiverse-repo':
				command => 'perl -ne \'m|^#\s*(deb(?:-src)?\s+http://.*\s+multiverse\n)|s and print $1\' /etc/apt/sources.list > /etc/apt/sources.list.d/multiverse.list; apt-get update',
				path => ['/usr/local/bin', '/bin', '/usr/bin'],
				creates => '/etc/apt/sources.list.d/multiverse.list',
			} -> Package<| |>

			package { 'libapache2-mod-fastcgi':
				ensure => latest,
				require => Package['apache2'],
				notify => Service['apache2-service'],
			}

			apache2::module { ['alias', 'actions', 'fastcgi']:
				ensure => 'enabled',
			}

			service { 'php5-fpm':
				ensure => running,
				enable => true,
				hasrestart => true,
				hasstatus => true,
				require => Package['php5-apache_module'],
			} <~ Php5::Plugin<| |>
		}

		default: {
			$php_handler = 'php5-script'

			Service['apache2-service'] <~ Php5::Plugin<| |>
		}
	}
}
