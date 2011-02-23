#!/bin/bash
export crosshome=/export/users/marcelog/cross-freebsd
export PATH=${crosshome}/bin:/bin:/usr/bin:/sbin:/usr/sbin
export LD_LIBRARY_PATH=${crosshome}/lib
export CFLAGS="-I${crosshome}/include -L${crosshome}/lib"
./configure --host=x86_64-pc-freebsd7 --prefix=${crosshome} ${@}
