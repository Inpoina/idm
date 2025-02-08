#!/bin/bash

# Baca file dan hapus newline untuk menangani blok multi-line
input=$(tr -d '\n' < results2.txt)

# Ekstrak setiap blok JSON dalam {}
blocks=$(echo "$input" | grep -oP '\{.*?\}')

# Hitung total blok untuk keperluan progres
total_blocks=$(echo "$blocks" | wc -l)

# Inisialisasi counter
counter=1

# File output
output_csv="output.txt"

# Tulis header ke file output
echo "Kunci,qty" > "$output_csv"

# Proses setiap blok JSON
while IFS= read -r block; do
    # Ambil nilai "Kunci" (misal: "10010081")
    kunci=$(echo "$block" | grep -oP '"Kunci":"\K\d+')

    # Ambil nilai "Isi" (misal: "0")
    isi=$(echo "$block" | grep -oP '"Isi":"\K[^"]+')

    # Hitung jumlah "|" dalam nilai "Isi"
    pipe_count=$(echo "$isi" | tr -cd '|' | wc -c)

    # Tambah 1 ke jumlah "|"
    pipe_count=$((pipe_count + 1))

    # Simpan hasil ke file output
    echo "$kunci,$pipe_count" >> "$output_csv"

    # Hitung persentase progres
    progress=$((counter * 100 / total_blocks))

    # Tampilkan progres di layar
    echo -ne "Processing: $counter/$total_blocks ($progress%)\r"

    # Tambah counter
    ((counter++))
done <<< "$blocks"

# Tampilkan pesan selesai
echo -e "\nProses selesai! Hasil disimpan di $output_csv"
