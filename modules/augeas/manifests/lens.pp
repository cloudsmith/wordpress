define augeas::lens($source) {
	file { "/usr/share/augeas/lenses/${name}.aug":
		ensure => present,
		source => "$source",
		owner => root,
		group => root,
		mode => 0644,
		require => Package['augeas-libs'],
	}
}
