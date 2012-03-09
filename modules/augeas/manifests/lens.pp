define augeas::lens($source) {
	include augeas

	file { "${augeas::lens_dir}/${name}.aug":
		ensure => present,
		source => "${source}",
		owner => root,
		group => root,
		mode => 0644,
		require => File["${augeas::lens_dir}"],
	}
}
