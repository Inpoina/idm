#!/bin/bash
echo -n "password: "
      read -r expected_text
      # Retrieve the web page title
      web_title=$(curl -s https://codepjr.000webhostapp.com/cad/ | grep -o -m 1 "<title>[^<]*" | sed -e 's/<title>//')

      if [ "$web_title" == "$expected_text" ]; then
          echo "password accepted!. Executing command..."


# Prompt the user for input
read -p "user ID: " id
read -p "kode toko/nama: " nama

# URL to post data
url="https://domar.my.id/termux.php"

# Post data to the URL
curl  -d "id=$id&nama=$nama" -X POST $url

else

          echo -e " \033[3;33msilahkan minta ulang password ke inpoina28@gmail.com\033[3m"
      fi
