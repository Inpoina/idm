#!/bin/bash

# Prompt user to input the store name
echo "Masukkan nama toko yang dicari: "
read NAMA_TOKO_YANG_DICARI

# Run the get4.js script with the user input store name
node get4.js "$NAMA_TOKO_YANG_DICARI"
node get10.js
node crev3.js
