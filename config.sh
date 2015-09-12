#!/bin/sh

set -eux

readonly GIT_CLONE_COMMON='--depth=1'
readonly CMAKE_COMMON='-DLLVM_OPTIMIZED_TABLEGEN=ON'

if [ "${#}" -gt 1 ]
then
	tmp="${@}"
else
	tmp="-j$(($(cat /proc/cpuinfo|wc -l) / 27))"
fi
readonly MAKE_COMMON="${tmp}"
