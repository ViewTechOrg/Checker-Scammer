#!/data/data/com.termux/files/usr/bin/bash
# Credit By Bayu Rizki A.M
# framework: Bash ID
# version: 1.0.1
# create: 2023

set -o pipefail
shopt -s expand_aliases
declare -ig __oo__insideTryCatch=0
declare -g paths="/data/data/com.termux/files/usr"
if test -f "$paths/BashID"; then mkdir ${paths}/BashID; fi

# DONT EDIT
#function Namespace:(){ a_path=$(pwd); source $a_path/lib/app.sh; eval $@ || false; }
DEBUG:(){ :; }

function Namespace:(){
	local args="$@"
	local script="${BASH_SOURCE[1]#./}"
	local lineNo="${BASH_LINENO[0]}"
	local undefinedObject="$*"
	local parse_space=$(sed 's/\[//g;s/\]//g' <<< "$args")
	local login=($parse_space)
	local Logging

	for Logging in "${login[@]}"; do
		DEBUG: $Logging
		eval "$Logging" || { cat <<< "[ERR] Tidak dapat masuk ke dalam ruang $Logging";echo; cat <<< "[INFO] Script > ${script} && line ~> ${lineNo}"; exit 22; }
	done
}

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
			if { builtin source "./lib/$__raw__"; }; then
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
			builtin source <(curl -sL --max-time 4 --connect-timeout 3 --compressed --insecure "$__url__") || { cat <<< "[*] gagal mengimport pake [${__export__:-0x53}]"; exit 77; }
		fi
	}

	eval __init__ || cat <<< "[*] Error"
}

throw:(){
	local __str__=$(sed 's/\[//g;s/\]//g' <<< "$@")
	local script="${BASH_SOURCE[1]#./}"
	local lineNo="${BASH_LINENO[0]}"

	echo -e "\033[93m[\033[91m!\033[93m]\033[0m $__str__"
	echo -e "\e[93m[\e[90mDEBUG\e[93m]\e[97m Script \e[92m-> \e[90m${script}\e[96m(\e[93m${lineNo}\e[96m)\e[0m"
	read __ppkjidjdd__
}

# Namespace function

STD::Log(){
	# Fungsi log untuk mencatat pesan error dan log biasa ke file log dan layar
	Std.log:(){
	    local level="$1"    # Level log (INFO, ERROR, DEBUG)
	    local message="$2"  # Pesan yang akan dicatat
	    local log_file=".app.log"  # Lokasi file log
	    local script="${BASH_SOURCE[1]#./}"
	    local lineNo="${BASH_LINENO[0]}"
	    local undefinedObject="$*"
	
	    # Cek apakah level log valid
	    if [[ -z "$level" || -z "$message" ]]; then
	        echo "[!] Invalid log function usage. Example: log INFO 'This is a message'"
	        return 1
	    fi
	
	    # Menentukan format log dengan waktu saat ini
	    local timestamp
	    timestamp=$(date +"%a %d %b %Y %H.%M.%S")
	
	    # Menampilkan pesan log ke layar sesuai dengan level
	    case "$level" in
	        INFO)
	        	local log_message="\e[92m[\e[90m${timestamp}\e[92m]\e[90m [\e[92m${level}\e[90m]\e[93m $message"
	            echo -e "$log_message\033[0m"  # Warna hijau untuk INFO
	            ;;
	        ERROR)
	        	local log_message="\e[92m[\e[90m${timestamp}\e[92m]\e[90m [\e[91m${level}\e[90m]\e[93m $message"
	            echo -e "$log_message\033[0m"  # Warna merah untuk ERROR
	            ;;
	        DEBUG)
	        	local log_message="\e[92m[\e[90m${timestamp}\e[92m]\e[90m [\e[93m${level}\e[90m]\e[97m $message"
	            echo -e "$log_message\033[0m"  # Warna biru untuk DEBUG
	            ;;
	        *)
	            echo -e "\e[30m[\e[91mWARNING\e[30m]\e[97m Invalid log level. Defaulting to INFO.\033[0m"
	            echo -e "\e[93m$log_message\033[0m"
	            ;;
	    esac
	
	    # Menyimpan pesan log ke dalam file
	    echo "$log_message" >> "$log_file"
	}
	
}

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

		
		# if try-catch is nested, then set +e before so the parent handler doesn't catch us
		alias try="[[ \$__oo__insideTryCatch -gt 0 ]] && set +e;
		           __oo__insideTryCatch+=1; ( set -e;
		           trap \"Exception.Capture \${LINENO}; \" ERR;"
		alias catch=" ); Exception.Extract \$? || "
		
		Exception.Capture() {
		    local script="${BASH_SOURCE[1]#./}"
		
		    if [[ ! -f ${paths}/tmp/stored_exception_source ]]; then
		        echo "$script" > ${paths}/tmp/stored_exception_source
		    fi
		    if [[ ! -f ${paths}/tmp/stored_exception_line ]]; then
		        echo "$1" > ${paths}/tmp/stored_exception_line
		    fi
		    return 0
		}
		
		Exception.Extract() {
		    if [[ $__oo__insideTryCatch -gt 1 ]]
		    then
		        set -e
		    fi
		
		    __oo__insideTryCatch+=-1
		
		    __EXCEPTION_CATCH__=( $(Exception.GetLastException) )
		
		    local retVal=$1
		    if [[ $retVal -gt 0 ]]
		    then
		        # BACKWARDS COMPATIBILE WAY:
		        # export __EXCEPTION_SOURCE__="${__EXCEPTION_CATCH__[(${#__EXCEPTION_CATCH__[@]}-1)]}"
		        # export __EXCEPTION_LINE__="${__EXCEPTION_CATCH__[(${#__EXCEPTION_CATCH__[@]}-2)]}"
		        export __EXCEPTION_SOURCE__="${__EXCEPTION_CATCH__[-1]}"
		        export __EXCEPTION_LINE__="${__EXCEPTION_CATCH__[-2]}"
		        export __EXCEPTION__="${__EXCEPTION_CATCH__[@]:0:(${#__EXCEPTION_CATCH__[@]} - 2)}"
		        return 1 # so that we may continue with a "catch"
		    fi
		}
		
		Exception.GetLastException() {
		    if [[ -f ${paths}/tmp/BashID/stored_exception ]] && [[ -f ${paths}/tmp/BashID/stored_exception_line ]] && [[ -f ${paths}/tmp/BashID/stored_exception_source ]]
		    then
		        cat ${paths}/tmp/BashID/stored_exception
		        cat ${paths}/tmp/BashID/stored_exception_line
		        cat ${paths}/tmp/BashID/stored_exception_source
		    else
		        echo -e " \n${BASH_LINENO[1]}\n${BASH_SOURCE[2]#./}"
		    fi
		
		    rm -f ${paths}/tmp/BashID/stored_exception ${paths}/tmp/BashID/stored_exception_line ${paths}/BashID/tmp/stored_exception_source
		    return 0
		}
			
	alias @return:="echo -e"
	
	@data.grep:(){
		local args1 args2
		args1="$1"; args2="$2"

		if [[ -z "$args1" ]] && [[ -z "$args2" ]]; then
			Std.log: ERROR "arg1* && arg2* tidak boleh kosong atau tidak di isi" || { cat <<< "[!] Error : args1 & args2 > @data.grep"; return 77; }
		fi
		if (grep -o "$args1" <<< "$args2") &>/dev/null; then
			true
		else
			false
		fi
	}
}

eval __import__
