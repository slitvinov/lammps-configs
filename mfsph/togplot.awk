#! /usr/bin/awk -f

fl{
  print
}

/ITEM: ATOMS/{
 fl = 1
}
