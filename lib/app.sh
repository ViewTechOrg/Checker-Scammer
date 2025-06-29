#!/data/data/com.termux/files/usr/bin/bash

function Namespace:(){ a_path=$(pwd); source $a_path/lib/app.sh; eval $@ || false; }

: 77 = error modul
: 22 = error syntax
: 33 = error import app

function __import__(){
	function __init__(){
		shopt -s expand_aliases

		alias import.app="__import__::app"
		alias import.source="__import__::source"
	}

	__import__::source(){
		__apps__=$(sed 's/\[//g;s/\]//g;s/\,/ /g;s/\:/\//g' <<< "$@")
		# __files__=$({ sed 's/\[//g;s/\]//g' <<< "$__files__" || true; })
		__apps__=$({ sed 's/[[:space:]][[:space:]]/ /g' <<< "$__apps__"; })

		local __toarrayapp__=(${__apps__})
		
		for __raw__ in "${__toarrayapp__[@]}"; do
			if { builtin source "lib/$__raw__"; }; then
				imported+=$(printf "$__raw__\n")
			else
				cat <<< "[*] Module [$__raw__] tidak di temukan"
				exit 33
			fi
		done
	}

	__import__::app(){
		__url__=$(sed 's/\[//g;s/\]//g' <<< "$@")

		if (test -f "$__url__"); then
			for __export__ in $(cat "$__url__"); do
				builtin source <(curl -sL --max-time 4 --connect-timeout 3 --compressed --insecure "$__export__") || { cat <<< "[*] gagal mengimport pake [$__export__]"; exit 77; }
				imported+=$(echo "$__export__")
			done
		else
			builtin source <(curl -sL --max-time 4 --connect-timeout 3 --compressed --insecure "$__url__") || { cat <<< "[*] gagal mengimport pake [$__export__]"; exit 77; }
		fi
	}

	eval __init__ || cat <<< "[*] Error"
}

throw:(){
	__str__=$(sed 's/\[//g;s/\]//g' <<< "$@")

	printf "\033[93m[\033[91m!\033[93m]\033[0m $__str__"
	read __ppkjidjdd__
}

# Namespace function

Std::Main(){
	shopt -s expand_aliases
	
	alias io.write="printf"

	function join:(){ local IFS="$1"; shift; echo "${*}"; }
	function __string__(){
		function __init__(){
			shopt -s expand_aliases

			alias string.upper="__string__::upper"
			alias string.lower="__string__::lower"
			alias string.capital="__string__::capital"
			alias string="__string__"
		}

		__string__::upper(){
			read __raw__
			cat <<< "$(tr \"a-z\" \"A-Z\" <<< \"$__raw__\")"
		}

		__string__::lower(){
			read __raw__
			cat <<< "$(tr \"A-Z\" \"a-z\" <<< \"$__raw__\")"
		}

		__string__::capital(){
			read __raw__
			cat <<< "${__raw__^}"
		}

		__string__(){
			throw: ["hanya bisa di akses oleh pipe"]
			exit 77
		}

		eval __init__ || echo "[*] Error"
	}

	eval __string__

	async:(){
		"$@" &
	}

	await(){
		for xpid in $(jobs -p); do
			wait "$xpid"
		done
	}

	@return:(){
		eval "echo \"\$$@\""
	}
}

eval __import__
