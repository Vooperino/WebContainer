apt-get update
apt-get install libpcre3-dev libssl-dev perl make build-essential curl wget gnupg ca-certificates -y
wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
codename=`grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release`

echo "deb http://openresty.org/package/debian $codename openresty" \
    | tee /etc/apt/sources.list.d/openresty.list
apt-get update    
echo "Installing openresty!"

apt-get -y install openresty

echo "Configuring Clean Install and Default Configuration!"

echo "Updating Clean Install Dir"
cp -r -f -v /temp_config/* /clean/config
cp -r -f -v /temp_scripts/* /clean/scripts

echo "Updating Config Dir"
cp -r -f -v /temp_config/* /config/
cp -r -f -v /temp_scripts/* /scripts

echo "Updating Service"
cp -r -f -v /openresty.service /clean
#cp -r -f -v /openresty.service /usr/lib/systemd/system/

cp -r -f -v /scripts/reloadWebSrv.sh /usr/bin/reloadWebSrv
chmod 555 -R /usr/bin/reloadWebSrv

echo "Updating Default page"
mkdir /usr/local/openresty/nginx/html
cp -r -f -v /clean/config/defaults/page/webdata/* /usr/local/openresty/nginx/html
chmod 777 -R /usr/local/openresty/nginx/html/*

echo "=== End of script ==="