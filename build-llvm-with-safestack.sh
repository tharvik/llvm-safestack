#!/bin/sh

readonly SCRIPT_DIR="${0%/*}"
. "${SCRIPT_DIR}/config.sh"

readonly LLVM_RECOMPILE_SRC='llvm-self'
readonly CMAKE_INSTALL_PREFIX='root'
readonly GIT_BASE_URL='https://github.com/tharvik'
readonly GIT_BRANCH='self_build_safestack'

readonly ROOT_DIR="${PWD}"
readonly INSTALL_ROOT="${ROOT_DIR}/llvm/build/${CMAKE_INSTALL_PREFIX}"
git_clone_common="${GIT_CLONE_COMMON} --branch ${GIT_BRANCH}"

# setup
git clone ${git_clone_common} "${GIT_BASE_URL}/llvm.git"
cd llvm

cd tools
git clone ${git_clone_common} "${GIT_BASE_URL}/clang.git"
cd ..

cd projects
git clone ${git_clone_common} "${GIT_BASE_URL}/compiler-rt.git"
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/libcxx.git"
git clone ${git_clone_common} "${GIT_BASE_URL}/libcxxabi.git"
cd ..

mkdir build
cd ..

rsync -a --del llvm/ "${LLVM_RECOMPILE_SRC}"

# first build
cd llvm/build
cmake	${CMAKE_COMMON}						\
	-DCMAKE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}" ..
make ${MAKE_COMMON}
make ${MAKE_COMMON} install
cd ../..

# second build
cd "${LLVM_RECOMPILE_SRC}/build"
cmake	${CMAKE_COMMON}						\
	-DLLVM_USE_SANITIZER='Safestack'			\
	-DCMAKE_C_COMPILER="${INSTALL_ROOT}/bin/clang"		\
	-DCMAKE_CXX_COMPILER="${INSTALL_ROOT}/bin/clang++" ..
make ${MAKE_COMMON}
cd ../..
