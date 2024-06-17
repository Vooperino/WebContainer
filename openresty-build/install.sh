LUA_VER="5.4.6"
LUAROCK_VER="3.11.0"
CURRECT_DIR=$(pwd)

apt-get update
apt-get install libpcre3-dev libssl-dev perl make build-essential curl wget gnupg ca-certificates libreadline-dev unzip -y

echo "Installing LUA ($LUA_VER) and LuaRock ($LUAROCK_VER)"
curl -R -O http://www.lua.org/ftp/lua-${LUA_VER}.tar.gz
tar -zxf lua-${LUA_VER}.tar.gz
rm lua-${LUA_VER}.tar.gz
cd lua-${LUA_VER}
make linux test
make install
cd ${CURRECT_DIR}

export PATH=$PATH:/usr/local/bin

wget https://luarocks.org/releases/luarocks-${LUAROCK_VER}.tar.gz
tar zxpf luarocks-${LUAROCK_VER}.tar.gz
rm luarocks-${LUAROCK_VER}.tar.gz
cd luarocks-${LUAROCK_VER}
./configure --with-lua-include=/usr/local/include
make install
cd ${CURRECT_DIR}

rm -rf lua-${LUA_VER}
rm -rf luarocks-${LUAROCK_VER}

echo "Pre-installing Lua Libs"
luarocks install lua-resty-openidc

echo "Installing Openresty"
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

cp -r -f -v /scripts/reloadWebSrv.sh /usr/bin/reloadWebSrv
cp -r -f -v /scripts/reloadCustomLua.sh /usr/bin/reloadCustomLua
chmod 555 -R /usr/bin/reloadWebSrv
chmod 555 -R /usr/bin/reloadCustomLua

echo "Updating Default page"
mkdir /usr/local/openresty/nginx/html
cp -r -f -v /clean/config/defaults/page/webdata/* /usr/local/openresty/nginx/html
chmod 777 -R /usr/local/openresty/nginx/html/*

echo "=== End of script ==="