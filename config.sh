#!/bin/sh

set -eux

readonly GIT_CLONE_COMMON='--depth=2 --no-single-branch'
readonly CMAKE_COMMON='-DLLVM_OPTIMIZED_TABLEGEN=ON'

if [ "${#}" -gt 0 ]
then
	tmp="${@}"
else
	tmp=$(($(cat /proc/cpuinfo|wc -l) / 27))
	tmp="-l${tmp} -j$((${tmp} * 2))"
fi
readonly MAKE_COMMON="${tmp}"
