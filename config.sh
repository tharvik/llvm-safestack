#!/bin/sh

set -eux

readonly GIT_CLONE_COMMON='--depth=1 --no-single-branch'
readonly CMAKE_COMMON='-DLLVM_OPTIMIZED_TABLEGEN=ON'

if [ "${#}" -gt 0 ]
then
	tmp="${@}"
else
	tmp=$(($(cat /proc/cpuinfo|wc -l) / 27))
	tmp="-j${tmp} -l$((${tmp} * 2))"
fi
readonly MAKE_COMMON="${tmp}"
