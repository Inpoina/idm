
mv ~/storage/shared/kampret/query/UGD_STMAST.csv ~/storage/shared/kampret/UGD_STMAST.csv
mv ~/storage/shared/kampret/UGD_STMAST.csv ~/idm/

mariadb -u root -proot <<EOF
use idm;
delete from stok;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/UGD_STMAST.csv'
INTO TABLE stok
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF
