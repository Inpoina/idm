tail -c 388 /storage/emulated/0/kampret/domar/*  > hasil3.txt

awk -v str='SecaraTunai":' '{if (index($0, str) > 0) print substr($0, index($0, str) + length(str), 8);}' hasil3.txt > final.txt

mv final.txt /sdcard/kampret/final.txt



spinner="/|\\-"
count=0
duration=5
end=$((SECONDS+duration))

while [ $SECONDS -lt $end ]; do
    echo -n -e "\r\033[K[${spinner:$count % 4:1}] Loading..."
    sleep 0.1
    ((count++))
done

echo -e "\r\033[KProses berhasil! Silahkan cek file final.txt di folder kampret"
