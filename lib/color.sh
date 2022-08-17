# https://forum.archlabslinux.com/t/script-to-convert-hex-color-codes-to-rgb-and-rgb-to-hex-on-the-fly/3107

hex_to_rgb() {
    if [[ $1 =~ ([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2}) ]]; then
        printf "(%d, %d, %d)\n" \
            0x"${BASH_REMATCH[1]}" 0x"${BASH_REMATCH[2]}" 0x"${BASH_REMATCH[3]}"
    fi

}

rgb_to_hex() {
    if [[ $1 =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]; then
        printf "#%02x%02x%02x\n" \
            "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
    fi
}