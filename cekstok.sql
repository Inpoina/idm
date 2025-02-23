SELECT 
   
    t1.plu,
    REPLACE(REPLACE(t1.deskripsi, CHAR(13), ''), CHAR(10), ' ') AS deskripsi,
    COALESCE(t2.qty, 0) AS stok_awal,
    COALESCE(SUM(t3.qty), 0) AS stok_keluar,
    COALESCE(t2.qty, 0) - COALESCE(SUM(t3.qty), 0) AS stok_akhir
FROM list t1
LEFT JOIN stok t2 ON t1.plu = t2.plu
LEFT JOIN sold t3 ON t1.plu = t3.plu
GROUP BY t1.id, t1.plu, t1.deskripsi, t2.qty
ORDER BY t1.id;
EOF
