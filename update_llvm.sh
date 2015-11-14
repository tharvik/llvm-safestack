#!/bin/sh

readonly DIR=/var/tmp

set -eux

update()
{
	local dir="${1}"

	rsync -a --del				\
		--exclude-from='FREEBSD-Xlist'	\
		--exclude='FREEBSD-Xlist'	\
		--exclude='tools/clang'		\
		"${DIR}/${dir}/" .
}

cd "${DIR}"
for r in llvm clang
do
	if [ ! -d "${r}" ]
	then
		git clone "https://github.com/llvm-mirror/${r}.git"
	fi
done

cd /usr/src

cd contrib/llvm
update llvm

cd tools/clang
update clang
