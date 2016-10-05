safe_ln () { # create a symbolic link even if it exists
    test -L "$2" && rm -f "$2"
    ln   -s   "$1" "$2"
}
