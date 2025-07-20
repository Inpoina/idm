# Move the file

mv ~/storage/shared/kampret/query/UGD_RAK.csv ~/storage/shared/kampret/UGD_RAK.csv                                                 
mv ~/storage/shared/kampret/UGD_RAK.csv ~/idm/

# Run MariaDB commands
mariadb -u root -proot <<EOF
use idm;
delete from modis;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/UGD_RAK.csv'
INTO TABLE modis
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF
