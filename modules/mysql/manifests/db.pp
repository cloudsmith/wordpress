define mysql::db($user, $password) {
	exec { "mysql_db_create-${name}":
		unless => "mysql -u'root' ${name}",
		command => "mysql -u'root' -e 'create database ${name};'",
		path => ['/usr/local/bin', '/bin', '/usr/bin'],
		require => Service['mysql-service'],
	}

	exec { "mysql_db_grant_privileges-${name}":
		unless => "mysql -u'${user}' -p'${password}' ${name}",
		command => "mysql -u'root' -e \"grant all on ${name}.* to '${user}'@'localhost' identified by '${password}'; flush privileges;\"",
		path => ['/usr/local/bin', '/bin', '/usr/bin'],
		require => [Service['mysql-service'], Exec["mysql_db_create-${name}"]],
	}
}
