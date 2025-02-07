#!/bin/bash

# Tanyakan kepada pengguna apakah ingin memperbarui data
read -p "Update data sebelum menampilkan tabel? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    bash q.sh && bash q4.sh
fi

# File sumber data penjualan (output.txt tetap)
DATA_FILE="output.txt"

# Path dasar untuk file PLU
BASE_PATH="/storage/emulated/0/kampret"

# Minta input nama file PLU kepada pengguna
default_filename="plu.txt"
read -p "Masukkan nama file PLU (default: $default_filename): " filename
if [ -z "$filename" ]; then
    filename="$default_filename"
fi
ID_FILE="${BASE_PATH}/${filename}"

# Lebar tetap untuk tiap kolom
PLU_WIDTH=8
DESC_WIDTH=40
SALES_WIDTH=7

# Cetak header tabel
printf "%-${PLU_WIDTH}s | %-${DESC_WIDTH}s | %-${SALES_WIDTH}s\n" "PLU" "DESCRIPTION" "SALES"
printf "%s\n" "--------------------------------------------------------------"

# Fungsi untuk membungkus teks panjang ke beberapa baris
wrap_text() {
    local text="$1"
    local width="$2"
    local wrapped=""
    while IFS= read -r line; do
        wrapped+="$line"$'\n'
    done < <(echo "$text" | fold -s -w "$width")
    echo "$wrapped"
}

# Proses setiap baris dari file PLU
while IFS= read -r line; do
    # Pisahkan PLU dan Deskripsi
    id=$(echo "$line" | awk '{print $1}')
    desc=$(echo "$line" | cut -d' ' -f2-)

    # Hitung total sales dari output.txt berdasarkan PLU
    sum=$(awk -F',' -v id="$id" '$1 == id {sum += $2} END {print sum+0}' "$DATA_FILE")

    # Bungkus deskripsi jika terlalu panjang
    wrapped_desc=$(wrap_text "$desc" "$DESC_WIDTH")

    # Ambil baris pertama dari deskripsi untuk dicetak di baris utama
    first_line=$(echo "$wrapped_desc" | head -n 1)

    # Cetak baris pertama dengan format tabel
    printf "%-${PLU_WIDTH}s | %-${DESC_WIDTH}s | %-${SALES_WIDTH}d\n" "$id" "$first_line" "$sum"

    # Cetak sisa baris jika ada (untuk deskripsi yang lebih panjang)
    echo "$wrapped_desc" | tail -n +2 | while IFS= read -r extra_line; do
        printf "%-${PLU_WIDTH}s | %-${DESC_WIDTH}s | %-${SALES_WIDTH}s\n" "" "$extra_line" ""
    done

    # Cetak pemisah
    printf "%s\n" "--------------------------------------------------------------"
done < "$ID_FILE"
