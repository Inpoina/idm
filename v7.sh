#!/bin/bash

# Pastikan file kunci.txt ada
if [[ ! -f "kunci.txt" ]]; then
    echo "Error: File kunci.txt tidak ditemukan!"
    exit 1
fi

# Baca daftar kunci dari file dan simpan dalam array
mapfile -t kunci_list < kunci.txt

# Gabungkan kunci ke dalam pola regex untuk pencocokan cepat
kunci_pattern=$(printf "|%s" "${kunci_list[@]}")
kunci_pattern=${kunci_pattern:1} # Hapus karakter "|" pertama

# Baca isi file JSON dan hapus newline
input=$(tr -d '\n' < results2.txt)

# Ambil semua blok JSON yang berada dalam {}
blocks=$(echo "$input" | grep -oP '\{.*?\}')

# Nama file output
output_file="output.txt"

# Bersihkan isi file output jika ada
> "$output_file"

# Loop untuk setiap blok JSON yang ditemukan
while IFS= read -r block; do
    # Ambil nilai "Kunci"
    kunci=$(echo "$block" | grep -oP '"Kunci":"\K\d+')

    # Cek apakah Kunci ada dalam daftar kunci.txt
    if grep -q -w "$kunci" <<< "${kunci_list[*]}"; then
        # Ambil nilai "Isi"
        isi=$(echo "$block" | grep -oP '"Isi":"\K[^"]+')

        # Hitung jumlah "|" dalam Isi
        pipe_count=$(echo "$isi" | grep -o '|' | wc -l)

        # Tambahkan 1 ke pipe count
        pipe_count=$((pipe_count + 1))

        # Simpan hasil ke file output
        echo "$kunci,$pipe_count" >> "$output_file"
    fi
done <<< "$blocks"

echo "Output saved to $output_file"
