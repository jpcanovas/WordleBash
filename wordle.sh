#!/bin/bash
WORD_FILE='words.txt'
COUNTER=5

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

get_word_and_check() {
	echo "${COUNTER}: Introduzca una palabra de 5 letras "
	read -p "-> " USER_WORD

	if [ ${#USER_WORD} -gt 5 ]; then
		msg "${RED}La palabra tiene más de 5 letras${NOFORMAT}"
		return 0
	elif [ ${#USER_WORD} -lt 5 ]; then
		msg "${RED}La palabra tiene menos de 5 letras${NOFORMAT}"
		return 0
	else
		((COUNTER--))
		for ((i=0; i < 5; i++)); do
			if [ ${USER_WORD:$i:1} == ${RWORD:$i:1} ]; then
				msg "${GREEN}${USER_WORD:$i:1}${NOFORMAT}"
			elif [[ ${RWORD} == *"${USER_WORD:$i:1}"* ]]; then
				msg "${YELLOW}${USER_WORD:$i:1}${NOFORMAT}"	
			else
				msg "${RED}${USER_WORD:$i:1}${NOFORMAT}"
			fi
		done
		# echo "<${USER_WORD}> vs <${RWORD}>"
		if [ ${USER_WORD} = ${RWORD} ]; then
			return 1
		else
			return 0
		fi
	fi
}

setup_colors
mapfile -t < $WORD_FILE
NWORDS=${#MAPFILE[*]}
RAND=$(($RANDOM % NWORDS))
RWORD=${MAPFILE[${RAND}]}

get_word_and_check
while [ $? -eq 0 -a $COUNTER -ne 0 ]; do
	get_word_and_check
done
if [ $COUNTER -gt 0 ]; then
	msg "${GREEN}¡CONSEGUIDO!${NOFORMAT}"
else
	msg "La palabra era ${PURPLE}${RWORD}${NOFORMAT}"
fi
