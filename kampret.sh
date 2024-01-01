echo "





 .
                            .

                              .
                              .             .        .
                             . .     .........
                        .;:::..,'...''.'''''''.
                      .'do;'' .'.'ONNX;''..'''  .
                     ..oc;:cl'.:'KXxWWK.o0Ol'.
                    ':d0NNNNX0,K:dd.lMW:M0OW:  .
                 ..dXNWWNNXXKKKK'.  ,M0cll K0.
                 .0XWWWNNNNNXXKKo. .0Xd,.  KO..
                 oKNWWNXXNNNXXKKKolkkx0k''xNdOc.  .xko.
          'l,    o0XWNXKKXXOd0KKK0K0KKKK0kkk00Oo.  .kk,:do,''
         .0Kl.  ,.OKNNXKKKKKd0KKKK0KKKKKKXXXXXKO,.,lKK0oxxOl
         .,l0dlddlloxXNKKKKK0co0KKKKKKKKXXNNNNK0;lKKK0Oo
        codl00KKKXXKxldXKKKKKK;.:ok0KKKK0k0XKK0x,OOOo
       .ldxxk0OkkO0KKKkcdKK000l,o,...:lodO00OOlckk;
       cxx;          .x0xc;lxOO;;:cokOOOOOxoolxkc
                        'kd',dl'l;;:,;loo;.dkkd
                          .xx:o..'.....;,cOOk,
                             ok;..''''';,':;
                               .'''''''';c:..
                              ..''''''''';co..
                            ..'''''''''''';cd..
                          ...'''''''''''''';ld..
                         ..'lk::'Oddldd;x:c'ooo
                        ..''cXkd'XxOOdk00X0cX0X..
                        .''',,,,';,',::;;,,ccdOl
                      ..'''''''''''''''''''';okd
                       '''''''''''''''''''';cdOo
                     ..''''''''''''''''''''::k0,
                       '.''''''''''''''..c00k'o
                       odc;,'........ .lKNXK;
               .:olc;,,'',;lddxxdoolox0KXXk
             .'doc::;,,,,,,',dxkO000000Oo,
                ..........';;'lodddol:;',''.
                    ....'...        ',,,,,,;,'.
                                      .,,,,,:ll.
                                         .,,;cd0.
                                            .';k."









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

