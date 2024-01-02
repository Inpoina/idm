

jp2a images.png --colors


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

echo -n "Calculating total..."
sleep 1
echo -n .
sleep 1
echo -n .
sleep 1
echo -n .
sleep 1
awk '{ sum += $1 } END { printf " Rp %'\''d\n", sum }' final2.txt

