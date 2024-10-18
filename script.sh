#!/usr/bin/env bash
set -euo pipefail

# variables declaration
SLEEP_TIME=0.05

RED_COLOR="\e[31m"
GREEN_COLOR="\e[32m"
END_COLOR="\e[0m"

# setup sliding symbol based on program run input
# with no flag provided - * (star) will be used as default
if [[ $# -eq 0 ]]; then
	SYMBOL='*'
else
	SYMBOL=$1
fi

# section to catch and handle exit from program by ctrl+c combination
# * - clear screen and show cursor
trap ctrl_c INT

function ctrl_c() {
        tput cnorm
	clear
	exit
}

# main body
function main {

	clear
	array=("[$SYMBOL     ]" "[ $SYMBOL    ]" "[  $SYMBOL   ]"	"[   $SYMBOL  ]" "[    $SYMBOL ]" "[     $SYMBOL]" "[    $SYMBOL ]" "[   $SYMBOL  ]" "[  $SYMBOL   ]" "[ $SYMBOL    ]")

	# hide cursor
	tput civis

	base_index=0

	# main loop
	while [[ 1 ]]
	do
		for ix in ${!array[*]}
	        do
			if [[ $base_index == 1 ]]; then
			COLOR=$RED_COLOR
			else
			COLOR=$GREEN_COLOR
			fi

	                sleep $SLEEP_TIME
	                printf "\r%b" "${COLOR}${array[ix]}${END_COLOR}"
			base_index=$((1-$base_index))

	        done
	done
}

main
