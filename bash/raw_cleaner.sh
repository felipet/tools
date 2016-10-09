#! /usr/bin/env bash
# _____________________________________________________________________________
#
# Bash script to clean orphan RAW pictures from a directory.
#
# When I review the pictures from my digital camera, I use to check the JPG
# files and erase them when the picture is not properly taken. This makes the
# RAW files remain in the folder.
#
# This script list all the pictures from a folder and erases RAW files which
# haven't got a JPG file associated (they share the same name).
#
# TODO:
# - Recursive search. (Nested folders are not supported)
#
# Authors:
# - Felipe Torres González(torresfelipex1<AT>gmail.com)
#
# _____________________________________________________________________________

# Default args
RAW_FORMAT="RAF"
REMOVE_FOLDER="toremove"
SAFE=0
LIST_DIR=

help() {
cat << EOF
Bash script to clean orphan RAW pictures from a directory.

Usage: raw_cleaner [options]

Options:
-h | --help     Print this help
-d | --dir      Enter a custom directory to scan (otherwhise .)
-s | --safe     Run in safe mode. The RAW files will be moved to a folder
                instead of be deleted.
EOF
exit 0
}

main() {
    mkdir -p $REMOVE_FOLDER

    if [ x$LIST_DIR == x"" ];
    then
        pictures=`ls .`
    else
        pictures=`ls $LIST_DIR`
    fi

    for pic in $pictures
    do
        if [[ $pic =~ .*$RAW_FORMAT.* ]]
        then
            jpg_pic=$(echo $pic | sed 's/RAF/JPG/g')
            (echo $pictures | grep $jpg_pic) >> /dev/null
            if [[ $? == 1 ]]
            then
                mv $pic $REMOVE_FOLDER
            fi
        fi
    done

    if [ x$SAFE != x1 ]
    then
        echo -e "RAW files erased\n"
        rm -r $REMOVE_FOLDER
    else
        echo -e "RAW files moved to $REMOVE_FOLDER\n"
    fi
}

while [ $# -gt 0 ]
do
    case "$1" in
        -h | --help) help;;
        -d | --dir) LIST_DIR=$2; shift 2;;
        -s | --safe) SAFE=1; shift;;
        *) echo -e "Unknow argument: $1"; help;;
    esac
done

main
