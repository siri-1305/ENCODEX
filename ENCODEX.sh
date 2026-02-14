#!/bin/bash
clear

# ================= Colors & Styles =================
BOLD="\e[1m"
RESET="\e[0m"
CYAN="\e[36m"
MAGENTA="\e[35m"

echo "=================================================================="
echo "                      WELCOME TO ENCODEX                          "
echo "=================================================================="
echo ""

# ================= Loop for continuous use =================
while true; do
    echo "First select your MODE - (ENCODING[1] OR DECODING[2]) or type 0 to EXIT"
    read -p "Enter 1, 2, or 0: " mode

    if [[ "$mode" == "0" ]]; then
        echo "Exiting ENCODEX. Goodbye!"
        break
    fi

    echo ""

    if [[ $mode == 1 ]] ; then
        echo "NOW SELECT WHICH ENCODING METHOD YOU WANT TO USE -"
        echo "1) TEXT TO BINARY"
        echo "2) ASCII ENCODE"
        echo "3) BASE64 ENCODE"
        echo "4) HEX ENCODE"
        echo "5) XOR"
        echo "6) BASE32"
        echo "7) ROT13"
        read -p "ENTER METHOD (1-7): " method
        echo ""
        read -p "ENTER THE INPUT DATA YOU WANT TO ENCODE: " data
    else
        echo "NOW SELECT WHICH DECODING METHOD YOU WANT TO USE -"
        echo "1) BINARY TO TEXT (8 bits each, separated by space)"
        echo "2) ASCII DECODE (numbers separated by space)"
        echo "3) BASE64 DECODE"
        echo "4) HEX DECODE"
        echo "5) XOR"
        echo "6) BASE32"
        echo "7) ROT13"
        read -p "ENTER METHOD (1-7): " method
        echo ""
        read -p "ENTER THE INPUT DATA YOU WANT TO DECODE: " data
    fi

    echo ""

    # -------------------- ENCODING --------------------
    if [[ $mode == 1 && $method == 1 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        for (( i=0; i<${#data}; i++ )); do
            char="${data:$i:1}"
            ascii=$(printf "%d" "'$char")
            binary=$(echo "obase=2; $ascii" | bc)
            printf "%08d " "$binary"
        done
        echo

    elif [[ $mode == 1 && $method == 2 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        echo -n "$data" | od -An -t u1
        echo

    elif [[ $mode == 1 && $method == 3 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        echo -n "$data" | base64
        echo

    elif [[ $mode == 1 && $method == 4 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        echo -n "$data" | xxd -p
        echo

    elif [[ $mode == 1 && $method == 5 ]]; then
        read -p "Enter key (single character or number): " key
        output=""
        key_num=$([[ ${#key} -eq 1 ]] && printf "%d" "'$key" || echo "$key")
        for (( i=0; i<${#data}; i++ )); do
            char="${data:$i:1}"
            ascii=$(printf "%d" "'$char")
            xor=$((ascii ^ key_num))
            output+=$(printf "\\$(printf '%03o' "$xor")")
        done
        echo -e "${BOLD}${CYAN}ENCODED OUTPUT:${RESET} $output"

    elif [[ $mode == 1 && $method == 6 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        echo -n "$data" | base32
        echo

    elif [[ $mode == 1 && $method == 7 ]]; then
        echo -e "${BOLD}${CYAN}ENCODED DATA:${RESET}"
        echo "$data" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
    fi

    # -------------------- DECODING --------------------
    if [[ $mode == 2 && $method == 1 ]]; then
        output=""
        for b in $data; do
            decimal=$((2#$b))
            output+=$(printf "\\$(printf '%03o' "$decimal")")
        done
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET} $output"

    elif [[ $mode == 2 && $method == 2 ]]; then
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET}"
        echo "$data" | awk '{for(i=1;i<=NF;i++) printf "%c",$i; print ""}'

    elif [[ $mode == 2 && $method == 3 ]]; then
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET}"
        echo -n "$data" | base64 --decode
        echo

    elif [[ $mode == 2 && $method == 4 ]]; then
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET}"
        echo -n "$data" | xxd -r -p
        echo

    elif [[ $mode == 2 && $method == 5 ]]; then
        read -p "Enter key (single character or number): " key
        output=""
        key_num=$([[ ${#key} -eq 1 ]] && printf "%d" "'$key" || echo "$key")
        for (( i=0; i<${#data}; i++ )); do
            char="${data:$i:1}"
            ascii=$(printf "%d" "'$char")
            xor=$((ascii ^ key_num))
            output+=$(printf "\\$(printf '%03o' "$xor")")
        done
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET} $output"

    elif [[ $mode == 2 && $method == 6 ]]; then
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET}"
        echo -n "$data" | base32 --decode
        echo

    elif [[ $mode == 2 && $method == 7 ]]; then
        echo -e "${BOLD}${MAGENTA}DECODED DATA:${RESET}"
        echo "$data" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
    fi

    echo ""
    echo "----------------------------------------------"
    echo ""
done
