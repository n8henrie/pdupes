#!/bin/bash

########    User settings     ############
MAXDIRS=5
MAXDEPTH=5
MAXFILES=10
MAXSIZE=1000
DUPS=20
######## End of user settings ############

# How deep in the file system are we now?
TOP=$(pwd | tr -cd '/' | wc -c)

# http://linuxgazette.net/153/pfeiffer.html
populate() {
	cd $1
	curdir=$PWD

	files=$(($RANDOM*$MAXFILES/32767+1))
  for n in $(seq $files); do
    f=$(mktemp XXXXXX)
		size=$(($RANDOM*$MAXSIZE/32767+1))
		head -c $size /dev/urandom > $f
	done

  depth=$(pwd | tr -cd '/' | wc -c)
	if [ $(($depth-$TOP)) -ge $MAXDEPTH ]; then
		return
	fi

	unset dirlist
	dirs=$(($RANDOM*$MAXDIRS/32767+1))
  for n in $(seq $dirs); do
    d=$(mktemp -d XXXXXX)
		dirlist="$dirlist${dirlist:+ }$PWD/$d"
	done

	for dir in $dirlist; do
		populate "$dir"
	done
}

makedups() {
  for n in $(seq $DUPS); do
    old_f="$(find "$1" -type f | gsort --random-sort --random-source=/dev/urandom | head -n 1)"
    dest="$(find "$1" -type d | gsort --random-sort --random-source=/dev/urandom | head -n 1)"
    new_f="$(head -c 24 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)"
    cp -f "${old_f}" "${dest}/${new_f}"
  done
}

echo "Creating directory tree with junk files"
pushd "test_files" >/dev/null
populate "$PWD"
popd >/dev/null
echo "Creating duplicates of the junk files"
pushd "test_files" >/dev/null
makedups "$PWD"
popd >/dev/null
echo "Done"
