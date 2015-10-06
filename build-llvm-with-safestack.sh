#!/bin/bash

readonly SCRIPT_DIR="${0%/*}"
. "${SCRIPT_DIR}/config.sh"

readonly CMAKE_INSTALL_PREFIX='root'
readonly GIT_BASE_URL='https://github.com/tharvik'
readonly GIT_BRANCH='self_build_safestack'

readonly ROOT_DIR="${PWD}"
readonly INSTALL_ROOT="${ROOT_DIR}/llvm/build/${CMAKE_INSTALL_PREFIX}"
git_clone_common="${GIT_CLONE_COMMON} --branch ${GIT_BRANCH}"

# cleanup
rm -rf llvm llvm-patches

# setup
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/llvm.git" llvm
cd llvm

cd tools
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/clang.git"
cd ..

cd projects
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/compiler-rt.git"
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/libcxx.git"
git clone ${GIT_CLONE_COMMON} "${GIT_BASE_URL}/libcxxabi.git"
git clone ${GIT_CLONE_COMMON} "https://github.com/llvm-mirror/test-suite.git"
cd ..

mkdir build
cd ..

rsync -a --del llvm/ llvm-patches

for p in llvm-patches/{tools/clang,projects/compiler-rt}
do
	pushd "${p}"
	git checkout "${GIT_BRANCH}"
	popd
done

# build for safestack support
cd llvm/build
cmake	${CMAKE_COMMON}						\
	-DCMAKE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}" ..
make ${MAKE_COMMON}
make ${MAKE_COMMON} install
make ${MAKE_COMMON} check-all | tee tests-results
cd ../..

# build with patches
cd llvm-patches/build
cmake	${CMAKE_COMMON}						\
	-DCMAKE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}" ..
make ${MAKE_COMMON}
make ${MAKE_COMMON} install
make ${MAKE_COMMON} check-all | tee tests-results
cd ../..
