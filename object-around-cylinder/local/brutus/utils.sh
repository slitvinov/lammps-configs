safe_ln () {
    test -L "$2" && rm -f "$2"
    ln   -s   "$1" "$2"
}
