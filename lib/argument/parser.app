#!/data/data/com.termux/files/usr/bin/bash

DEBUG: argument/parser.app

function parser(){
	function __init__(){
		local __getdata__=$(sed 's/^\[\[//;s/\]\]$//;s/,/ /g;s/[[:space:]][[:space:]]/ /g' <<< "$@")
		#local __getdata__=$(sed 's/^\[//;s/\]$//;s/,/ /g;s/[[:space:]][[:space:]]/ /g' <<< "$@")

		cat <<< "$__getdata__"
		# |tr -d '"'|sed 's/ */"&"/g;s/"//;s/""/"/g;s/"=/=/g'
	}

	 __init__ "$@" || echo "[*] error"
}

parser.all:(){
	local data=$(parser ["$@"])
	eval "$this=($data)"
	# eval "Array_myparser=($data)"
	#local xparse

	# for xparse in "${Array_myparser[@]}"; do
	# 	@return: "$xparse"
	# done
}
