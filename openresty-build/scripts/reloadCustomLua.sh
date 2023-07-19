#!/usr/bin/env bash

output() {
    echo "Output: $@"
}

checkDir() {
    [ -d "$@" ]
}

lua_root_path="/usr/local/share/lua/5.4"
lua_custom_path="/config/lua"

if ! checkDir $lua_custom_path; then
    output "Custom Lua directory found was not found! Creating..."
    mkdir -vp $lua_custom_path
    chmod -R 777 $lua_custom_path
    if checkDir $lua_custom_path; then
        output "Custom Lua directory was created!"
    else
        output "Failed to create custom lua directory"
        exit 255
    fi
fi

for dir in "$lua_custom_path"/*; do
    if checkDir $dir; then
        dir_name=$(basename "$dir")
        output "Copying $dir_name"
        if checkDir $lua_root_path/$dir_name; then
            rm -rf "$lua_root_path/$dir_name"
        fi
        cp -r -f "$lua_custom_path/$dir_name" "$lua_root_path"
    fi
done