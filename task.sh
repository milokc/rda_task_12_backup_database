#!/bin/bash

# Full backup ShopDB > ShopDBReserve
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --databases ShopDB > backup.sql

# Data only backup ShopDB > ShopDBDevelopment
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --no-create-db --no-create-info ShopDB > backup_data.sql

# Recovery ShopDB > ShopDBReserve
sed 's/ShopDB/ShopDBReserve/g' backup.sql > backup_reserve.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "DROP DATABASE IF EXISTS ShopDBReserve;"
mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE ShopDBReserve;"
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBReserve < backup_reserve.sql
rm backup_reserve.sql

# Data only recovery ShopDB > ShopDBDevelopment
sed 's/ShopDB/ShopDBDevelopment/g' backup_data.sql > backup_dev.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ShopDBDevelopment;"
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBDevelopment < backup_dev.sql
rm backup_dev.sql
