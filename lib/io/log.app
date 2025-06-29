import.source [io/color.app]

# log.error
# log.print
# log.info


declare -A sets

: 1 = body
: 2 = awal
: 3 = function

__main:log__(){
	function __init__(){
		shopt -s expand_aliases

		alias log.error="__main__.error"
		alias log.print="__main__.print"
		alias log.info="__main__.info"

		sets[1]=$(__init:color__ ["mode","bold"]; eval color.hijau)
		sets[2]=$(__init:color__ ["mode","reset"])
	}

	__main__.error(){
		eval args=($(parser ["$@"]))
		
		sets[3]=$(__init:color__ ["mode","bold"]; eval color.merah)
		
		io.write "${sets[1]}[${sets[3]}ERROR${sets[1]}]${sets[2]} ${args[0]}"
	}

	__main__.print(){
		eval args=($(parser ["$@"]))

		sets[3]=$(__init:color__ ["mode","bold"]; eval color.kuning)

		io.write "${sets[1]}[${sets[3]}${args[0]}${sets[1]}]${sets[2]} ${args[1]}"
	}

	__main__.info(){
		eval args=($(parser ["$@"]))

		sets[3]=$(__init:color__ ["mode","bold"]; eval color.hijau)

		io.write "${sets[1]}[${sets[3]}INFO${sets[1]}]${sets[2]} ${args[0]}"
	}

	eval __init__
}
