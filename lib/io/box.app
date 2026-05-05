
import.source [argument:parser.app]

function __boxes__() {
	function __initBox__(){
		local Apps=($(parser ["$@"]))
  		local longest=0

  		if test "${Apps[0]}" == "text"; then
  		  read __stt__
  		  local string_array=("$__stt__")
  		for i in "${string_array[@]}"; do
    		if [[ "${#i}" -gt "${longest}" ]]; then
      			local longest=${#i}
      			local longest_line="${i}" # Longest line
    		fi
  		done

  		local edge=$(echo "$longest_line" | sed 's/./#/g' | sed 's/^#/###/' | sed 's/#$/###/')
  		local middle_edge=$(echo "$longest_line" | sed 's/./\ /g' | sed 's/^\ /#\  /' | sed 's/\ $/\ \ #/')

  		echo -e "\n${edge}"
  		echo "${middle_edge}"

  		for i in "${string_array[@]}"; do
    		local length_i=${#i}
    		local length_ll="${#longest_line}"
    		if [[ "${length_i}" -lt "${length_ll}"  ]]; then
            	printf "# "
            	local remaining_spaces=$((length_ll-length_l))
            	printf "${i}"
            	while [[ ${remaining_spaces} -gt ${#i} ]]; do
                    printf " "
                    local remaining_spaces=$((remaining_spaces-1))
            	done
            	printf " #\n"
    		else
      			echo "# ${i} #"
    		fi
  		done

  		echo "${middle_edge}"
  		echo -e "${edge}\n"
  		else
  			true
  		fi
	}

	shopt -s expand_aliases
	alias box="__initBox__"
}

eval __boxes__
