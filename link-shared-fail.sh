#!/bin/sh

readonly SCRIPT_DIR="${0%/*}"

readonly ROOT_DIR="${PWD}"
readonly INSTALL_ROOT="${ROOT_DIR}/llvm/build/root/bin"

echo "${INSTALL_ROOT}"
"${INSTALL_ROOT}/sanitize-clang" hello.c -fsanitize=safe-stack -fPIC -Wl,-z,defs -shared
