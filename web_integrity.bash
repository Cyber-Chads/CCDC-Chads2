#!/bin/bash

#file integrity

################HELP###################

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ -z $1 ]

then

        printf "\nRun in the form of: ./check /path/to/location/file1.txt /path/to/location/file2.txt\n"

            exit 0

fi

#############START####################

FILE1=$1

FILE1_HASH=`sha256sum $FILE1 | awk '{print $1}'`

FILE2=$2

FILE2_HASH=`sha256sum $FILE2 | awk '{print $1}'`

if [ "$FILE1_HASH" != "$FILE2_HASH" ]

then

            echo "File has changed"

else

            echo "File has not changed"

fi

###########done######################