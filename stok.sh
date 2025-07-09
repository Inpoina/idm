#!/bin/bash

# Your initial string
initial_string=""

# Set the filename for the ID
id_file="id.bin"

# Check if id.bin exists
if [ ! -e "$id_file" ]; then
    # Generate 6 random characters if id.bin does not exist
    random_chars=$(LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6)

    # Combine the initial string with random characters
    result_string="${initial_string}${random_chars}"

    # Save the result in the id.bin file
    echo "$result_string" > "$id_file"

    # Display a message for registration
    echo "Registration...."
else
    # Display a message if id.bin already exists
    echo "id accepted"
fi

# Read the ID from the file
id=$(<"$id_file")

# Check if the ID is listed on the web page
web_page_url="https://domarx.my.id"  # Replace with the actual web page URL
if curl -s "$web_page_url" | grep -q "$id"; then
    # Get the expected password from the user
    echo -n "password: "
    read -r expected_text

    # Retrieve the web page title
    web_title=$(curl -s https://domarx.my.id/password.html | grep -o -m 1 "<title>[^<]*" | sed -e 's/<title>//')

    if [ "$web_title" == "$expected_text" ]; then
        echo "Password accepted! Executing command..."

        # Continue with the rest of your script logic
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
                echo "Menjalankan crev7.js untuk PLU $PLU..."
                node crev7.js "$PLU"
                if [ $? -ne 0 ]; then
                    echo "Error occurred in crev7.js for PLU $PLU. Exiting."
                    break
                fi
            done
        else
            echo "Error occurred in get4.js. Exiting."
        fi
    else
        echo "Password does not match the expected value. Exiting."
    fi
else
    # Display the ID from id.bin if the ID is not found on the webpage
    echo "ID ($id) belum terdaftar"
fi
