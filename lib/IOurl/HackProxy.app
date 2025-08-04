
import.source [argument:parser.app]

target_url=""

function Urandom_useragent(){ local UASOURCE=$(curl -sL "https://gist.githubusercontent.com/pzb/b4b6f57144aea7827ae4/raw/cf847b76a142955b1410c8bcef3aabe221a63db1/user-agents.txt" --insecure --max-time 10); cat < <(sort -R <<< "$UASOURCE"|head -1); }

function PROXY(){
	declare -g this="ARGS"
	parser.all: "$@"
	eval "${ARGS[0]};${ARGS[1]}" # [0] = target url, [1] = mode http/socks5
	declare -g CountryProxy="${CountryProxy}"
	declare -g TargetProxy="${TargetProxy}"

	HackProxy.app.mode.scanning "${CountryProxy}" "${TargetProxy}"
	cat <<< "$proxy_valid"
	# export ALL_PROXY="$proxy_valid"
}

HackProxy.app.mode.scanning(){
	local set_mode
	local co="${1:-JP}"
	local url="${2:-false}"

	# check mode
	# if test "$mode" == "http"; then
	# 	set_mode="http://"
	# 	set.proxy(){ sort -R <<< "${proxy[1]}"|head -1; }
	# elif test "$mode" == "socks5"; then
	# 	set_mode="socks5://"
	# 	set.proxy(){ sort -R <<< "${proxy[0]}"|head -1; }
	# fi
	# check valid url
	set.proxy(){
		local length=${1}
		local country=${2}
		local dataproxy=$(curl -sL "https://free-proxy-list.net/#"|html2text)
		local scrap=$(tail +46 <<< "${dataproxy}"|head -${1}|grep "yes"|grep "${country}")

		# ambil proxy
		local proxymiti=$(grep -Po "\d+\.\d+\.\d+\.\d+\s+(\d+)" <<< "$scrap"|awk '{ print $1 ":" $2 }'|sort -R|head -1)
		cat <<< "${proxymiti:-false}"
	}
	
	if ! (grep -Po '(https|http)' <<< "${url}") &>/dev/null; then
		Std.log: ERROR "url tidak valid !!"
		return 4
	fi

	# check kecocokan proxy
	while true; do
		list_proxy=$(set.proxy "300" "$co")
		local kode=$(curl -sL "${url}" -A "$(Urandom_useragent)" --max-time 10 --connect-timeout 5 --proxy "${list_proxy}" --insecure -o /dev/null -w %{http_code})

		if ((${kode:-400} > 200 || ${kode:-400} != 200)); then
			continue
		else
			break
		fi
	done

	proxy_valid="${list_proxy}"
}

shopt -s expand_aliases

alias HackProxy.Running:="PROXY"
