class wordpress::internal::lens {
	augeas::lens { 'wordpress':
		source => 'puppet:///modules/wordpress/wordpress.aug',
	}
}
