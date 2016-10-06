emake () {
    eval make "$@"
}

safe_ln () { # create a symbolic link even if it exists
    test -L "$2" && rm -f "$2"
    ln   -s   "$1" "$2"
}

safe_cp () { # cp and log
    echo "(utils.sh) call: cp " "$@"
    cp "$@"
}

gdb_osx () { # print emacs gdb command
    gdb_file=$1; shift; gdb_args="$@"

    gdb_gen_script > $gdb_script

    gdb_emacs="$gdb_cmd --fullname $gdb_file -x $gdb_script"
    echo "(utils.sh) Emacs command to start remote gdb on \`$gdb_host' (do C-x C-e after the command)" | cat 2>&1
    printf '(gud-gdb "%s")\n' "$gdb_emacs" | cat 2>&1
}

gdb_gen_script () { # generate gdb script
cat <<EOF
set  args  $gdb_args
cd   `pwd`
start
EOF
}
