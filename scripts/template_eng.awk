#!/usr/bin/awk -f

/^@include/ {
    cmd = sprintf("cat %s\n", $2)
    system(cmd)
    next
}

{
    print
}
