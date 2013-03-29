define php5::plugin() {
	include php5::common

	package { $title:
		ensure => latest,
	}
}