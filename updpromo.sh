#!/bin/bash

# Move the file

mv ~/storage/shared/kampret/query/UGD_promo_matriks.csv ~/storage/shared/kampret/UGD_promo_matriks.csv
mv ~/storage/shared/kampret/UGD_promo_matriks.csv ~/idm/
#run maria db
mariadb -u root -proot <<EOF
use idm;
delete from promo;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/UGD_promo_matriks.csv'
INTO TABLE promo
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'           
IGNORE 1 ROWS;
