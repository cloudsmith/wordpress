class augeas {
	$lens_dir = '/var/lib/augeas'

	file { "${lens_dir}":
		ensure => directory,
		owner => root,
		group => root,
		mode => 0755,
	}
}
