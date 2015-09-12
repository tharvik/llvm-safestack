#!/bin/sh

readonly SCRIPT_DIR="${0%/*}"
. "${SCRIPT_DIR}/config.sh"

readonly LLVM_RECOMPILE_SRC='llvm-self'
readonly CMAKE_INSTALL_PREFIX='root'

readonly ROOT_DIR="${PWD}"
readonly INSTALL_ROOT="${ROOT_DIR}/llvm/build/${CMAKE_INSTALL_PREFIX}"

git clone ${GIT_CLONE_COMMON} https://github.com/llvm-mirror/llvm.git
cd llvm

cd tools
git clone ${GIT_CLONE_COMMON} https://github.com/llvm-mirror/clang.git
cd ..

cd projects
git clone ${GIT_CLONE_COMMON} https://github.com/llvm-mirror/compiler-rt.git
git clone ${GIT_CLONE_COMMON} https://github.com/llvm-mirror/libcxx.git
git clone ${GIT_CLONE_COMMON} https://github.com/llvm-mirror/libcxxabi.git
cd ..

mkdir build
cd ..

rsync -a llvm/ "${LLVM_RECOMPILE_SRC}"

# now we have to build everything

cd llvm/build
cmake	${CMAKE_COMMON}						\
	-DCMAKE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}" ..
make ${MAKE_COMMON}
make ${MAKE_COMMON} install
cd ../..

rsync -a sanitize* llvm/build/root/bin

cd "${LLVM_RECOMPILE_SRC}/build"
cmake	${CMAKE_COMMON}						\
	-DCMAKE_C_COMPILER="${INSTALL_ROOT}/bin/sanitize-clang"		\
	-DCMAKE_CXX_COMPILER="${INSTALL_ROOT}/bin/sanitize-clang++" ..
make ${MAKE_COMMON}
cd ../..
