# Cek apakah zip sudah terinstal
if ! command -v zip &> /dev/null
then
    echo "zip tidak ditemukan, menginstal..."
    pkg install zip
else
    echo "zip installed"
fi

# Membuat file zip dengan nama fix.zip dari semua file di folder ~/storage/shared/Kampret/domar/
zip -j fix.zip ~/storage/shared/Kampret/domar/*

# Memindahkan file fix.zip ke folder ~/storage/shared/Kampret/
mv *.zip ~/storage/shared/Kampret/

# Tampilkan pesan setelah selesai
echo "Proses selesai."
