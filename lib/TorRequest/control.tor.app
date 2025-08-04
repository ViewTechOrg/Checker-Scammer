# tor requets by pejuang kentang
# framework bash ID

import.source [argument:parser.app]
import.source [TorRequest:config.tor]

function CONTROL(){
	# setup stem to change_ip
	CONTROL.Change(){ unset LD_PRELOAD;python -c "from stem.control import Controller, Signal; c = Controller.from_port(port=9051); c.authenticate('alex'); c.signal(Signal.NEWNYM); c.close()";sleep 2;set.ld_preload; }
	CONTROL.scanning(){
		# check server apakah sudah aktif atau belum
		#local data_netstat=$(netstat -tunlp|grep "tor")
			mypelis="${@:-ifconfig.me}"
			# check apakah koneksi benar benar bisa di gunakan
			connection=$(curl -sL --max-time 10 --connect-timeout 5 "${mypelis}" -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.1 (KHTML, like Gecko) Chrome/4.0.219.4 Safari/532.1" --insecure)
			#local connection=$(torify parallel -j 50 --fast "https" ::: "GET" ::: "https://ifconfig.me" ::: "--all" ::: "--body" ::: "--follow" ::: "--print" ::: "h" ::: "2>/dev/null"|sed 's/[A-Z]*\=//g'|tr -d '\n'|head -1|awk '{ print $2 }')
			statusConnect=$connection
			# { readonly __torTime__=$(($(date +%-M)+1)) &>/dev/null; }
			let retry=5
			let start=0

			if ((connection == 200)); then {
				declare -g status_code="$statusConnect"
				# debug
				declare -g torMSG=$(Std.log: DEBUG "\e[97mConnection \e[95mTor \e[90m${bind_default}\e[94m:\e[90m${bind_port} \e[93m-\e[90m>\e[92m Success")
				# export ALL_PROXY="${bind_default}:${bind_port}"
			}; else {
				# proses akan di ulang sampai mendapatkan proxy yang valid
				# waktu timeout 1 menit
				# let realtime_timeoutTor=$(date +%-M)
				
				# if ((statusConnect > 200)) || ! ((statusConnect == 200)); then
				while true; do
					{ eval CONTROL.Change; }
					declare -g exception_control_change_ip="$stateTrace"
					#echo "$exception_control_change_ip"
					# timeout
					if ((start == retry)); then
						unset __torTime__
						CONTROL.Change
						__tordebug__="failed to change ip"
						# break
					fi

					connection=$(curl -sL --retry 4  "${mypelis}" -o /dev/null -w "%{http_code}" --insecure 2>&1)
					outs=$(curl -sL --retry 4 "${mypelis}" --insecure -I 2>&1)
					#echo "$connection"
					if ! { grep -o "HTTP/[0-9] 415" <<< "$outs"; } &>/dev/null || ((connection == 200)); then { break; };else continue; fi
					
					let start++
				done
			}; fi
	}

	CONTROL.torify(){ set.ld_preload; }
	CONTROL.reset(){ unset LD_PRELOAD; }

	__initControl__(){
		declare -g this="ParseArgs"
		parser.all: "$@"

		# echo "${ParseArgs[@]}"
		eval "${ParseArgs[0]};${ParseArgs[1]}" 2>/dev/null || { Std.log: ERROR "\e[93mError: in [$@] | exception ~ Argument tidak valid" 1>&2; return 3; }
	}

	__initControl__ "$@"
}


shopt -s expand_aliases

alias control.tor.socks5:="CONTROL"
