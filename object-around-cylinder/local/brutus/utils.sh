safe_ln () {
    test -h "$2" && rm "$2"
    ln -s   "$1" "$2"
}
