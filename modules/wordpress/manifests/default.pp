class wordpress::default {
	wordpress::instance { 'blog':
	}

# If a second blog instance is wanted
#	wordpress::instance { 'blog2':
#		dbname => 'wordpress2',
#	}
}
