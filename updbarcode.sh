mv ~/storage/shared/kampret/query/UGD_BARCODE.csv ~/storage/shared/kampret/UGD_BARCODE.csv
mv ~/storage/shared/kampret/UGD_BARCODE.csv ~/idm/

mariadb -u root -proot <<EOF
use idm;
delete from barcode;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/UGD_BARCODE.csv'
INTO TABLE barcode
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF
