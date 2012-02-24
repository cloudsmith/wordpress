define apache2::config_include($content) {
	# TODO verify the locataion of config includes accross distros
	$apache_config_include_dir = $::operatingsystem ? {
		Ubuntu => '/etc/httpd/conf.d',
		CentOS => '/etc/httpd/conf.d',
		Debian => '/etc/httpd/conf.d',
		default => '/etc/httpd/conf.d',
	}

	file { "${apache_config_include_dir}/${name}.conf":
		ensure => present,
		content => "${content}",
		owner => root,
		group => root,
		mode => 0644,
		require => Package['apache2'],
		notify => Service['apache2-service'],
	}
}
