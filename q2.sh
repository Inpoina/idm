#!/bin/bash

# Read the file content and remove newlines to handle multi-line blocks
input=$(tr -d '\n' < results2.txt)

# Extract each JSON object block enclosed in {}
blocks=$(echo "$input" | grep -oP '\{.*?\}')

# Initialize counter
counter=1

# Process each block to extract "Kunci" and "Isi" values
while IFS= read -r block; do
    # Extract KUNCİ value (e.g., "10010081")
    kunci=$(echo "$block" | grep -oP '"Kunci":"\K\d+')
    # Extract ISI value (e.g., "0")
    isi=$(echo "$block" | grep -oP '"Isi":"\K[^"]+')
    
    # Check if ISI contains "|" and split it
    if [[ "$isi" == *"|"* ]]; then
        # Replace "|" with ","
        isi_combined=$(echo "$isi" | tr '|' ',')
        echo "$counter. $kunci,$isi_combined"
    else
        echo "$counter. $kunci,$isi"
    fi
    ((counter++))
done <<< "$blocks"
