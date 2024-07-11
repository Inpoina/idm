apt update
apt upgrade
mv ~/idm/id.bin ~/id.bin
rm -rf idm
git clone https://github.com/Inpoina/idm.git
mv id.bin ~/idm/id.bin
echo "================================="
echo "sukses"
