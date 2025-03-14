#!/data/data/com.termux/files/usr/bin/sh
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
mariadb -u root -proot <<EOF
USE idm;
DELETE FROM sold;
LOAD DATA LOCAL INFILE '/data/data/com.termux/files/home/idm/sold.csv'
INTO TABLE sold
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

EOF

echo "✅ Data berhasil diperbarui!"
