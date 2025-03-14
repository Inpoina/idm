GNU nano 8.3                   queryclean.sh
mariadb -u root -proot -t -e "
USE idm;
SELECT 
   
    t1.plu,
        REPLACE(REPLACE(t1.deskripsi, CHAR(13), ''), CHAR(10), ' ') AS deskripsi, 
   
    COALESCE(t2.qty, 0) -
    COALESCE(SUM(t3.qty), 0) as stok
FROM kue t1
LEFT JOIN stok t2 ON t1.plu = t2.plu
LEFT JOIN sold t3 ON t1.plu = t3.plu
LEFT JOIN produk t4 ON t1.plu = t4.plu
GROUP BY t1.id, t1.plu, t1.deskripsi, t2.qty, t4.price
ORDER BY t1.id;
"
