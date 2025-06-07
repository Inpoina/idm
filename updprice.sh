#!/bin/bash

# Move the file

mv ~/storage/shared/kampret/query/UGD_PRODMAST.csv ~/storage/shared/kampret/UGD_PRODMAST.csv
mv ~/storage/shared/kampret/UGD_PRODMAST.csv ~/idm/ 

# Run MariaDB commands
mariadb -u root -proot <<EOF
use idm;
delete from produk;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/UGD_PRODMAST.csv'
INTO TABLE produk
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF
