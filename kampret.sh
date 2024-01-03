#!/bin/bash

# Get the expected text from the user
echo -n "password: "
read -r expected_text

# Retrieve the web page title
web_title=$(curl -s https://wificost.my.id/kampretsh/ | grep -o -m 1 "<title>[^<]*" | sed -e 's/<title>//')

if [ "$web_title" == "$expected_text" ]; then
    echo "password acepted!. Executing command..."
    # Replace the following line with your desired command
    # For example, echo "Hello, World!"
    
    
    jp2a logo.png --colors
    
    
    tail -c 388 /storage/emulated/0/kampret/domar/*  > hasil3.txt
    
    awk -v str='SecaraTunai":' '{if (index($0, str) > 0) print substr($0, index($0, str) + length(str), 8);}' hasil3.txt > final.txt
    
    
    
    spinner="/|\\-"
    count=0
    duration=5
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
            sleep 0.02
        done
        echo  # Move to the next line after the animation
    }
    
    type_text "read database file....."
    sleep 1
    type_text "extract data....."
    sleep 1
    type_text "find price by struk..."
    sleep 1
    type_text "colecting..."
    
    
    
    spinner="/|\\-"
    count=0
    duration=5
    end=$((SECONDS+duration))
    
    while [ $SECONDS -lt $end ]; do
        echo -n -e "\r\033[K[${spinner:$count % 4:1}] calculating data....."
        sleep 0.1
        ((count++))
    done


    echo -e "\r\033[K"
    

    
    awk '{ sum += $1 } END { printf "\033[93m Rp %'\''d\n\033[0m", sum }' final2.txt
    echo -n "kurangi dengan stor/tarik tunai debit,isaku,ovo dll jika ada"
    
else
    echo "silahkan minta ulang password ke inpoina28@gmail.com"
fi
