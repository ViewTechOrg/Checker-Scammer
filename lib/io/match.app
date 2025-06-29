#!/data/data/com.termux/files/usr/bin/bash

# value score
: 70:75 = mendekati
: 75:80 = cocok
: 80:100 = cocok sekali

declare -i score
result=""

import.source [argument:parser.app]

system.null(){
	let toarg=1
	for nill in "$@"
	do {
		if test -z "$nill"; then {
			cat <<< "[!] argument $toarg tidak boleh kosong"
			exit 3
		}; else {
			true
		}; fi

		let toarg++
	}; done
}
function __main__()
{
	function __init__(){
		shopt -s expand_aliases

		alias match.int="__main__::int"
		alias match.str="__main__::str"
		alias match.str.matrix="__main__::matrix"
	}

	__main__::int(){
		eval args=($(parser ["$@"]))

		system.null ${args[@]}
		local value1="${args[0]}"
		local value2=$(cat <<< "${args[1]}"|sed 's/\\//g')
		local value3="${args[2]}"

		if (($value1 $value2 $value3)); then { result=$(cat <<< "true"); }; else { result=$(cat <<< "false"); }; fi

		cat <<< "$result"

		unset value1 value2 value3 result
	}

	__main__::matrix(){
		eval args=($(parser ["$@"]))

		system.null ${args[@]}
		value1="${args[0]}"
		value2="${args[1]}"

		# Fungsi untuk menghitung jarak Levenshtein antara dua teks
		levenshtein_distance() {
  			local string1="$1"
  			local string2="$2"

  			local len1=${#string1}
  			local len2=${#string2}

  			# Membangun matriks jarak Levenshtein
  			for ((i = 0; i <= len1; i++)); do
    			matrix[$i,0]=$i
  			done

  			for ((j = 0; j <= len2; j++)); do
    			matrix[0,$j]=$j
  			done

  			for ((i = 1; i <= len1; i++)); do
    			for ((j = 1; j <= len2; j++)); do
      				deletion=$((matrix[$i-1,$j] + 1))
      				insertion=$((matrix[$i,$j-1] + 1))

      				substitution_cost=0
      				if [ "${string1:i-1:1}" != "${string2:j-1:1}" ]; then
        				substitution_cost=1
      				fi
      
      				substitution=$((matrix[$i-1,$j-1] + substitution_cost))

      				matrix[$i,$j]=$substitution
      				if ((deletion < matrix[$i,$j])); then
        				matrix[$i,$j]=$deletion
      				fi
      				if ((insertion < matrix[$i,$j])); then
        				matrix[$i,$j]=$insertion
      				fi
    			done
  			done

  			echo ${matrix[$len1,$len2]}
		}
		
		distance=$(levenshtein_distance "$value1" "$value2")
		cat <<< "$distance"

	}

	__main__::str(){
		eval args=($(parser ["$@"]))

		system.null ${args[@]}
		value1="${args[0]}"
		value2="${args[1]}"

		for reference in "$value2"
		do {
			score=0
			reference_lower=$(cat <<< "$reference"|tr "[:upper:]" "[:lower:]")

			for ((i = 0; i<${#value1}; i++))
			do
				for ((j = 0; j<${#reference}; j++))
				do
					if (test "${value1:$i:1}" == "${reference_lower:$j:1}"); then
						((score++))
						break
					fi
				done
			done
			result=$((100 * score / ${#value1}))
		}; done

		cat <<< "$result"
		unset value1 value2 result
	}

	eval __init__ || { echo "[*] Error"; exit; }
}

__main__
