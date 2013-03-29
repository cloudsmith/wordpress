define apache2::config_include($content) {
	# TODO verify the locataion of config includes accross distros
	$apache_config_include_dir = $::operatingsystem ? {
		Ubuntu => '/etc/apache2/conf.d',
		CentOS => '/etc/httpd/conf.d',
		Debian => '/etc/apache2/conf.d',
		default => '/etc/httpd/conf.d',
	}
	$apache_config_file_suffix = $::operatingsystem ? {
		Ubuntu => '',
		CentOS => '.conf',
		Debian => '',
		default => '.conf',
	}

	file { "${apache_config_include_dir}/${name}${$apache_config_file_suffix}":
		ensure => present,
		content => "${content}",
		owner => root,
		group => root,
		mode => 0644,
		require => Package['apache2'],
		notify => Service['apache2-service'],
	}
}
