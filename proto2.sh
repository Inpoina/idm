#!/bin/bash
bash q.sh && bash q4.sh
# File sumber data
DATA_FILE="output.txt"
ID_FILE="/storage/emulated/0/kampret/plu.txt"  # Update this to the correct path

# Cetak header tabel
echo "--------------------------------------------------"
echo "|  PLU     | DESCRIPTION                  |SALES |"
echo "--------------------------------------------------"

# Proses per ID dari plu.txt
while read -r id desc; do
    sum=$(awk -F',' -v id="$id" '$1 == id {sum += $2} END {print sum+0}' "$DATA_FILE")
    printf "| %-8s | %-28s | %-4d |\n" "$id" "$desc" "$sum"
done < "$ID_FILE"

echo "--------------------------------------------------"
