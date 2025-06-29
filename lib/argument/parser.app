#!/data/data/com.termux/files/usr/bin/bash

function parser(){
	function __init__(){
		local __getdata__=$(sed 's/^\[\[//;s/\]\]$//;s/,/ /g;s/[[:space:]][[:space:]]/ /g' <<< "$@")

		cat <<< "$__getdata__"
		# |tr -d '"'|sed 's/ */"&"/g;s/"//;s/""/"/g;s/"=/=/g'
	}

	 __init__ "$@" || echo "[*] error"
}
