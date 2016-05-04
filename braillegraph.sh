#!/usr/bin/env bash
#
# Copyright (c) 2016 by Patrick Burroughs <celti@celti.name>
# See LICENSE in the root of this repository or at https://github.com/Celti/braillegraph.sh/ for details.
#
# braillegraph.sh — prints a text-based bar graph made using braille characters.
# Usage: braillegraph.sh [h|v] <index> [<index> ...]
#  — h and v indicate a horizontal or vertical graph, respectively (default is horizontal if unspecified).
#  — further command-line arguments indicate the height of that column/row of the graph in braille dots.
#
# Example:
# $ ./braillegraph.sh h 3 2 1 4
# ⣦⣸
# $ ./braillegraph.sh v 3 2 1 4
# ⣟⣁
# $ ./braillegraph.sh h $(seq 1 3 32) $(seq 31 -2 1) $(seq 12 -1 1) $(seq 1 12)
# ⠀⠀⠀⠀⠀⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⣸⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⢠⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⣾⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⣸⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⢸⣦⡀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡇
# ⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⢸⣿⣿⣦⡀⠀⠀⠀⢀⣴⣿⣿⡇
# ⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣸⣿⣿⣿⣿⣦⣀⣴⣿⣿⣿⣿⡇

function char() { printf "\u28${char[${1}]}"; }
declare -A char=([00]='00' [01]='80' [02]='A0' [03]='B0' [04]='B8'
                 [10]='40' [11]='C0' [12]='E0' [13]='F0' [14]='F8'
                 [20]='44' [21]='C4' [22]='E4' [23]='F4' [24]='FC'
                 [30]='46' [31]='C6' [32]='E6' [33]='F6' [34]='FE'
                 [40]='47' [41]='C7' [42]='E7' [43]='F7' [44]='FF'
                 [0000]='00' [0001]='40' [0002]='C0' [0010]='04'
                 [0011]='44' [0012]='C4' [0020]='24' [0021]='64'
                 [0022]='E4' [0100]='02' [0101]='42' [0102]='C2'
                 [0110]='06' [0111]='46' [0112]='C6' [0120]='26'
                 [0121]='66' [0122]='E6' [0200]='12' [0201]='52'
                 [0202]='D2' [0210]='16' [0211]='56' [0212]='D6'
                 [0220]='36' [0221]='76' [0222]='F6' [1000]='01'
                 [1001]='41' [1002]='C1' [1010]='05' [1011]='45'
                 [1012]='C5' [1020]='25' [1021]='65' [1022]='E5'
                 [1100]='03' [1101]='43' [1102]='C3' [1110]='07'
                 [1111]='47' [1112]='C7' [1120]='27' [1121]='67'
                 [1122]='E7' [1200]='13' [1201]='53' [1202]='D3'
                 [1210]='17' [1211]='57' [1212]='D7' [1220]='37'
                 [1221]='77' [1222]='F7' [2000]='09' [2001]='49'
                 [2002]='C9' [2010]='0D' [2011]='4D' [2012]='CD'
                 [2020]='2D' [2021]='6D' [2022]='ED' [2100]='0B'
                 [2101]='4B' [2102]='CB' [2110]='0F' [2111]='4F'
                 [2112]='CF' [2120]='2F' [2121]='6F' [2122]='EF'
                 [2200]='1B' [2201]='5B' [2202]='DB' [2210]='1F'
                 [2211]='5F' [2212]='DF' [2220]='3F' [2221]='7F'
                 [2222]='FF')

function vertical() {
	local -a rows lines
	local -i row=0 column=0 line=0 cols=0 length=1
	local -i rowA rowB rowC rowD columnA columnB columnC columnD
	readonly rows=("${@}")

	for row in "${rows[@]}"; do
		length="$(( (row + 1) / 2 ))"
		cols="$(( length > cols ? length : cols ))"
	done

	for (( row=0; row < "${#rows[@]}"; line++ )); do
		rowA="${rows[$row]}" && ((row++))
		rowB="${rows[$row]}" && ((row++))
		rowC="${rows[$row]}" && ((row++))
		rowD="${rows[$row]}" && ((row++))

		for (( column=1; column <= cols; column++ )); do
			length="$(( (column - 1) * 2 ))"
			columnA="$(( rowA > length && rowA - length > 2 ? 2 : rowA - length ))"
			columnB="$(( rowB > length && rowB - length > 2 ? 2 : rowB - length ))"
			columnC="$(( rowC > length && rowC - length > 2 ? 2 : rowC - length ))"
			columnD="$(( rowD > length && rowD - length > 2 ? 2 : rowD - length ))"
			columnA="$(( columnA < 0 ? 0 : columnA ))"
			columnB="$(( columnB < 0 ? 0 : columnB ))"
			columnC="$(( columnC < 0 ? 0 : columnC ))"
			columnD="$(( columnD < 0 ? 0 : columnD ))"
			lines[${line}]+="$(char "${columnA}${columnB}${columnC}${columnD}")"
		done
	done

	printf "%s\n" "${lines[@]}"
	exit 0
}

function horizontal() {
	local -a columns lines
	local -i row=0 column=0 rows=1 height=1
	local -i columnA columnB rowA rowB
	readonly columns=("${@}")

	for column in "${columns[@]}"; do
		height="$(( (column + 3) / 4 ))"
		rows="$(( height > rows ? height : rows ))"
	done

	for (( column=0; column < "${#columns[@]}"; )); do
		columnA="${columns[$column]}" && ((column++))
		columnB="${columns[$column]}" && ((column++))

		for (( row=rows; row > 0; row-- )); do
			height="$(( (row - 1) * 4 ))"
			rowA="$(( columnA > height && columnA - height > 4 ? 4 : columnA - height ))"
			rowB="$(( columnB > height && columnB - height > 4 ? 4 : columnB - height ))"
			rowA="$(( rowA < 0 ? 0 : rowA ))"
			rowB="$(( rowB < 0 ? 0 : rowB ))"
			lines[${row}]+="$(char "${rowA}${rowB}")"
		done
	done

	printf "%s\n" "${lines[@]}" | tac
	exit 0
}

if [[ "${1}" == 'v' ]]; then
	graph='vertical' && shift
elif [[ "${1}" == 'h' ]]; then
	graph='horizontal' && shift
fi

if ! [ "${1}" -eq "${1}"  ]; then
	echo "Usage: $(basename "${0}") [v|h] <index> [<index>...]"
	exit 1
fi

${graph:-horizontal} "${@}"
