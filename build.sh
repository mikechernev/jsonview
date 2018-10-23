#!/bin/sh -e

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

tsc -p ${BASEDIR}
echo "${BASEDIR}"
PATH="${PATH}:${BASEDIR}/node_modules/.bin"

rm -rf ${BASEDIR}/build
mkdir -p ${BASEDIR}/build
rollup ${BASEDIR}/ts-out/background.js --format iife --name 'background' --file ${BASEDIR}/build/background.js
rollup ${BASEDIR}/ts-out/content.js --format iife --name 'background' --file ${BASEDIR}/build/content.js
rollup ${BASEDIR}/ts-out/viewer.js --format iife --name 'background' --file ${BASEDIR}/build/viewer.js
cp ${BASEDIR}/src/viewer.css ${BASEDIR}/build/viewer.css
cp ${BASEDIR}/src/manifest.json ${BASEDIR}/build/manifest.json
cp ${BASEDIR}/license.txt ${BASEDIR}/build/license.txt
cp -r ${BASEDIR}/src/_locales ${BASEDIR}/build
cp ${BASEDIR}/src/icon*.png ${BASEDIR}/build

# Doing force delete to prevent the `yarn start` command from failing if the file is missing
rm -f ${BASEDIR}/jsonview.zip
pushd ${BASEDIR}/build
zip -r ../jsonview.zip *
popd
