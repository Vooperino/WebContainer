echo "Installing openresty!"

apt-get -y install software-properties-common
add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
apt-get update
apt-get install openresty

echo "Configuring Clean Install and Default Configuration!"

echo "Updating Clean Install Dir"
cp -r -f -v /temp_config/* /clean/config
cp -r -f -v /temp_scripts/* /clean/scripts

echo "Updating Config Dir"
cp -r -f -v /temp_config/* /config/
cp -r -f -v /temp_scripts/* /scripts

cp -r -f -v /scripts/reloadWebSrv.sh /usr/bin/reloadWebSrv
chmod 555 -R /usr/bin/reloadWebSrv

echo "=== End of script ==="