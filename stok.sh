#!/bin/bash

# Prompt user to input the store name (only once)
echo "nama user: "
read NAMA_TOKO_YANG_DICARI

# Run the get4.js script with the user input store name
node get4.js "$NAMA_TOKO_YANG_DICARI"
if [ $? -eq 0 ]; then
    # If there was no error in get4.js, run the other scripts
    node get10.js
    rm refreshToken.txt
    node crev7.js

    # Move the file to the destination folder
    mv stok.xlsx ~/storage/shared/kampret/

    # Loop to prompt user for multiple PLU inputs
    while true; do
        while true; do
            echo "cek stok lagi ? 'y' atau ketik 'n' untuk berhenti: "
            read PLU

            # Check if input is 'y' or 'n'
            if [ "$PLU" == "y" ]; then
                # If 'y', continue the loop
                break
            elif [ "$PLU" == "n" ]; then
                echo "Berhenti memasukkan PLU. Keluar."
                break 2
            else
                # If input is not 'y' or 'n', ask again
                echo "Input tidak valid, silakan ketik 'y' atau 'n'."
            fi
        done

        # If the user provided a PLU, run crev7.js with the current PLU
        echo "running $PLU..."
        node crev7.js "$PLU"
        if [ $? -ne 0 ]; then
            echo "Error occurred in crev7.js for PLU $PLU. Exiting."
            break
        fi
    done
else
    echo "Error occurred in get4.js. Exiting."
fi
