#!/data/data/com.termux/files/usr/bin/bash

import.source [argument:parser.app]

: app := color

function __color__(){
	__init:color__(){
		shopt -s expand_aliases

		local __array__=($(parser ["$@"]))

		if test "${__array__[0]}" == "mode"; then
			if test "${__array__[1]}" == "bold"; then
				io.write "\033[1m"
			else
				io.write "\033[0m"
			fi
		else
			cat <<< "[*] ${__array__[@]} maksud anda -> [mode]"
			exit 77
		fi
		
		alias color.hitam="__color__::hitam"
		alias color.merah="__color__::merah"
		alias color.hijau="__color__::hijau"
		alias color.kuning="__color__::kuning"
		alias color.biru="__color__::biru"
		alias color.magenta="__color__::magenta"
		alias color.cyan="__color__::cyan"
		alias color.putih="__color__::putih"
		alias color.bg.hitam="__color__::bg::hitam"
		alias color.bg.merah="__color__::bg::merah"
		alias color.bg.hijau="__color__::bg::hijau"
		alias color.bg.kuning="__color__::bg::kuning"
		alias color.bg.biru="__color__::bg::biru"
		alias color.bg.magenta="__color__::bg::magenta"
		alias color.bg.cyan="__color__::bg::cyan"
		alias color.bg.putih="__color__::bg::putih"
		alias color.reset="__color__::reset"
	}

	__color__::hitam(){ io.write "\033[30m"; }
	__color__::merah(){ io.write "\033[31m"; }
	__color__::hijau(){ io.write "\033[32m"; }
	__color__::kuning(){ io.write "\033[33m"; }
	__color__::biru(){ io.write "\033[34m"; }
	__color__::magenta(){ io.write "\033[35m"; }
	__color__::cyan(){ io.write "\033[36m"; }
	__color__::putih(){ io.write "\033[37m"; }
	__color__::bg::hitam(){ io.write "\033[40m"; }
	__color__::bg::merah(){ io.write "\033[41m"; }
	__color__::bg::hijau(){ io.write "\033[42m"; }
	__color__::bg::kuning(){ io.write "\033[43m"; }
	__color__::bg::biru(){ io.write "\033[44m"; }
	__color__::bg::magenta(){ io.write "\033[45m"; }
	__color__::bg::cyan(){ io.write "\033[46m"; }
	__color__::bg::putih(){ io.write "\033[47m"; }
	__color__::reset(){ io.write "\033[00m"; }
}

__color__
