#! /usr/bin/env bash
set -euo pipefail

# coloring variables
DARK_GREY="\033[1;30m"
RED="\033[0;31m"
ORANGE="\033[0;33m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
BLUE_L="\033[1;34m"
PURPLE="\033[0;35m"
NO_COLOR="\033[0m"
GREEN="\033[0;32m"

# same ctrl+c cather as in v.1
trap ctrl_c INT

function ctrl_c() {
	tput cnorm
	clear
	exit
}

# To enlarge any sort of char to a long str
# [FUNCTION] [COUNTER] [CHAR]
# COUNTER: 0 -> +inf. On 0 will give bask empty string
# CHAR: any sort of str/char sequence
# example: "elongate_char 5 x" -> "xxxxx"
function elongate_char {

	count=$1
	char=$2

	if [[ $count -eq 0 ]]; then
		echo ""
	elif [[ $count -gt 0 ]]; then
		base=""
		# loop declaration which i don't understand...
		for ((i=1;i<=$count;i++)); do
		base+=$char
		done
		echo $base
	fi
}


# For given n will walk through 0-n-0 with i=1 iteration
# skeleton-function for future engine
function walker {

	# clear screen and hide cursor
	clear
	tput civis

	char_to_elongate="-"
	char_to_run="/"

	current_pos=0
	vector=-1

	cache_dimention_x=$(( $(stty size | awk '{print$2}') - 3))

	while [[ 1 ]]; do

		# adjust lenght of running line every time, whene it draws (based on terminal lenght)
		dimention_x=$(( $(stty size | awk '{print$2}') - 3))

		# clear the screen in case of adjusted terminal window - to remove leftovers
		if [[ $dimention_x -ne $cache_dimention_x ]]; then
			clear
			cache_dimention_x=$dimention_x
		fi

		# baking of bar itself [LEFT SIDE][RUNNING CHAR][RIGHT SIDE]
		left_side=$(elongate_char $current_pos $char_to_elongate)
		right_side=$(elongate_char $(($dimention_x - $current_pos)) $char_to_elongate)
		sum_str="[$left_side$char_to_run$right_side]"

		len_of_str=${#sum_str}
		len_of_str_div_3=$(($len_of_str / 7))
		temp_var=$(($len_of_str_div_3))
		temp_var2=$(($len_of_str_div_3 * 2))
		temp_var3=$(($len_of_str_div_3 * 3))
		temp_var4=$(($len_of_str_div_3 * 4))
		temp_var5=$(($len_of_str_div_3 * 5))
		temp_var6=$(($len_of_str_div_3 * 6))
		first_part="${RED}$(echo $sum_str | cut -c 1-$len_of_str_div_3)${NO_COLOR}"
		second_part="${ORANGE}$(echo $sum_str | cut -c $((temp_var+1))-$temp_var2)${NO_COLOR}"
		third_part="${YELLOW}$(echo $sum_str | cut -c $(($temp_var2+1))-$temp_var3)"
		fourth_part="${GREEN}$(echo $sum_str | cut -c $((temp_var3+1))-$temp_var4)"
		fifth_part="${BLUE_L}$(echo $sum_str | cut -c $((temp_var4+1))-$temp_var5)"
		sixth_part="${BLUE}$(echo $sum_str | cut -c $((temp_var5+1))-$temp_var6)"
		seventh_part="${PURPLE}$(echo $sum_str | cut -c $((temp_var6+1))-)"
		new_var="$first_part$second_part$third_part$fourth_part$fifth_part$sixth_part$seventh_part"

		# print-out to screen result of calculated bar
		printf "\r%b" "$new_var"

		# reverse vector of movement direction while reaching end points (0,last by sreen)
		if [[ $current_pos -eq 0 || $current_pos -eq "$dimention_x" ]]; then
			vector=$((-1 * $vector))
		fi

		current_pos=$(($current_pos + $vector))

		# error handling, in case of adjusting terminal space
		# i don't care that it's lame - it's just work duh
		if [[ $current_pos -gt $dimention_x ]]; then
			current_pos=$dimention_x
			vector=1
		elif [[ $current_pos -lt 0 ]]; then
			current_pos=0
			vector=-1
		fi

		sleep 0.005
	done
}

# run the walker
walker
