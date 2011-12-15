class wordpress::default {
	wordpress::instance { 'blog':
	}

	wordpress::instance { 'blog2':
		dbname => 'wordpress2',
	}
}
