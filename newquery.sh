#!/data/data/com.termux/files/usr/bin/sh

# Fungsi untuk menghentikan MySQL jika berjalan
stop_mysql() {
    if pgrep -x "mariadbd" > /dev/null; then
        echo "🔴 Menghentikan MySQL yang berjalan..."
        pkill -9 mariadbd
        sleep 3
    fi
}

# Fungsi untuk membersihkan file yang mungkin terkunci
clean_mysql_files() {
    echo "🧹 Membersihkan file yang terkunci..."
    rm -rf /data/data/com.termux/files/usr/var/lib/mysql/aria_log_control
    rm -rf /data/data/com.termux/files/usr/var/lib/mysql/ibdata1
}

# Fungsi untuk menjalankan ulang MariaDB
start_mysql() {
    if ! pgrep -x "mariadbd" > /dev/null; then
        echo "🚀 Memulai MySQL Server..."
        mariadbd-safe -u root &
        sleep 5
    else
        echo "✅ MySQL sudah berjalan."
    fi
}

# Periksa apakah MySQL berjalan, jika tidak, restart
if ! pgrep -x "mariadbd" > /dev/null; then
    echo "⚠️  MySQL tidak berjalan, mencoba memperbaiki..."
    stop_mysql
    clean_mysql_files
    start_mysql
else
    echo "✅ MySQL sudah berjalan."
fi

# Tanya pengguna apakah ingin update data
read -p "🔄 Update data sebelum menampilkan tabel? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "🔃 Memperbarui data..."
    bash q.sh && bash q4.sh
fi

# Pastikan file output.txt ada sebelum dipindahkan ke sold.csv
if [ -f "output.txt" ]; then
    mv output.txt sold.csv
else
    echo "⚠️ File output.txt tidak ditemukan, lanjut tanpa update file."
fi

# Jalankan perintah MariaDB
mariadb -u root <<EOF
USE idm;
DELETE FROM sold;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/sold.csv'
INTO TABLE sold
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 
   
    t1.plu,
    t1.deskripsi,
    COALESCE(t2.qty, 0) AS stok_awal,
    COALESCE(SUM(t3.qty), 0) AS stok_keluar,
    COALESCE(t2.qty, 0) - COALESCE(SUM(t3.qty), 0) AS stok_akhir
FROM list t1
LEFT JOIN stok t2 ON t1.plu = t2.plu
LEFT JOIN sold t3 ON t1.plu = t3.plu
GROUP BY t1.id, t1.plu, t1.deskripsi, t2.qty
ORDER BY t1.id;
EOF

echo "✅ Data berhasil diperbarui dan ditampilkan!"
