x=$(<x.bin)
openssl enc -d -aes-256-cbc -in aktual.sh -out final.sh -pass pass:"$x" && bash final.sh

