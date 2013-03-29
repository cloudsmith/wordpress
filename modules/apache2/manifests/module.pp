define apache2::module($ensure = 'enabled') {
	case $::operatingsystem {
		'debian', 'ubuntu': {
			case $ensure {
				'enabled': {
					$command = 'a2enmod'
					$test = '!'
				}

				default: {
					$command = 'a2dismod'
					$test = ''
				}
			}

			exec { "apache2-module-${title}":
				onlyif => "test ${test} -e '/etc/apache2/mods-enabled/${title}.load'",
				command => "${command} '${title}'",
				path => ['/usr/local/bin', '/sbin', '/bin', '/usr/sbin', '/usr/bin'],
				require => Package['apache2'],
				notify => Service['apache2-service'],
			}
		}

		default: {
			notice('not supported')
		}
	}
}