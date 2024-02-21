#version
version=v2
echo "script $version"

# URL of the web page
web_page_url="https://wificost.my.id/kampretsh/id/id.php"

# Check if the ID is listed on the web page
if curl -s "$web_page_url" | grep -q "$version"; then        
                             # Run your script here     

cp update.sh ~/
# Your initial string
initial_string=""

# Set the filename                     
filename="id.bin"

# Check if id.txt exists
if [ ! -e "$filename" ]; then
    # Generate 3 random characters
    random_chars=$(LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6)

    # Combine the initial string with random characters
    result_string="${initial_string}${random_chars}"

    # Save the result in a text file
    echo "$result_string" > "$filename"

    # Display a message
    echo "Registration...."
else
    # Display a message if id.txt already exists
    echo "id accepted"
fi

# File containing the ID
id_file="id.bin"

# Read the ID from the file
id=$(<"$id_file")

# Check if the ID is listed on the web page
if curl -s "$web_page_url" | grep -q "$id"; then                                     # Run your script here                                                                   # Get the expected text from the user
      echo -n "password: "
      read -r expected_text

      # Retrieve the web page title
      web_title=$(curl -s https://wificost.my.id/kampretsh/ | grep -o -m 1 "<title>[^<]*" | sed -e 's/<title>//')

      if [ "$web_title" == "$expected_text" ]; then
          echo "password accepted!. Executing command..."
          # Replace the following line with your desired command
          # For example, echo "Hello, World!"
	declare -a package_names=("cmatrix" "jp2a" "pup" )

for package in "${package_names[@]}"; do
  if dpkg -s "$package" &> /dev/null; then
    echo "$package is already installed."
  else
    echo "Installing $package..."
    pkg install -y "$package"
  fi
done

	cmatrix &
	sleep 4
	pkill -f cmatrix


          jp2a logo.png --colors

         echo -e  "\033[3;33mid : '$id'\033[3m "


          tail -c 415 /storage/emulated/0/kampret/domar/*  > hasil3.txt

          awk -v str='SecaraTunai":' '{if (index($0, str) > 0) print substr($0, index($0, str) + length(str), 8);}' hasil3.txt > final.txt



          spinner="/|\\-"
          count=0
          duration=3
          end=$((SECONDS+duration))

          while [ $SECONDS -lt $end ]; do
              echo -n -e "\r\033[K[${spinner:$count % 4:1}] Loading..."
              sleep 0.1
              ((count++))
          done

          awk -F'.' '{print $1}' final.txt > final2.txt

          echo -e "\r\033[K"

          while [ $SECONDS -lt $end ]; do
              echo -n -e "\r\033[K\033[92m[${spinner:$count % 4:1}] Loading...\033[0m"
              sleep 0.1
              ((count++))
          done

          awk -F'.' '{print $1}' final.txt > final2.txt

          echo -e "\r\033[K"


          function type_text {
              local text="$1"
              for ((i=0; i<${#text}; i++)); do
                  echo -n -e "\033[92m${text:$i:1}\033[0m"
                  sleep 0.01
              done
              echo  # Move to the next line after the animation
          }

          type_text "read database file....."
          sleep 1
          type_text "extract data....."
          sleep 1
          type_text "find price by struk..."
          sleep 1
          type_text "agar silaturahmi tidak putus transfer dulu seratus..."



          spinner="/|\\-"
          count=0
          duration=3
          end=$((SECONDS+duration))

          while [ $SECONDS -lt $end ]; do
              echo -n -e "\r\033[K[${spinner:$count % 4:1}] calculating data....."
              sleep 0.1
              ((count++))
          done

	 clear
	jp2a logo.png --colors
          echo -e "\r\033[K"


	
	sum=$(awk '{ sum += $1 } END { printf "\033[1;34m Rp %'\''d\n\033[0m", sum }' final2.txt | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
struk=$(wc -l final2.txt | awk '{print $1}')
echo -e "$sum"
echo -e "\033[1;34mTotal struk: $struk\033[0m"
          echo -n "kurangi dengan stor/tarik tunai debit,isaku,ovo dll jika ada"


          url="https://wificost.my.id/kampretsh/upd.html"
          body=$(curl -s "$url" | awk '/<body/,/<\/body>/{print}'|pup 'body text{}')
          echo -e "\033[3;33m$body\033[0m"



      else

          echo -e " \033[3;33msilahkan minta ulang password ke inpoina28@gmail.com\033[3m"
      fi







    else
echo "silahkan infokan ke inpoina28@gmail.com id: '$id'"
fi
else
echo "update dulu bos -------> bash update.sh"
fi
