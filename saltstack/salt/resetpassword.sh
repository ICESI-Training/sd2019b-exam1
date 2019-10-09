password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
mysqladmin --user=root --password="$password" password aaBB@@cc1122
mysql --user=root --password=aaBB@@cc1122 -e "UNINSTALL COMPONENT 'file://component_validate_password';"
mysqladmin --user=root --password="aaBB@@cc1122" password ""