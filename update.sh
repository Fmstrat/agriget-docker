#!/bin/bash

while [ ! -f /var/www/html/data/config.php ]; do
	echo "Config file does not exist yet, waiting 60s to try again before starting feed updates..."
	sleep 60
done

/bin/su www-data -s /bin/bash -c "/usr/local/bin/php /var/www/html/update_daemon2.php"
