#!/bin/sh

echo "------contact build start ----------------"

CONTACT_FRAMEWORKER_PATH="./framework"
if [ ! -d "$CONTACT_FRAMEWORKER_PATH" ]; then
    mkdir -p "$CONTACT_FRAMEWORKER_PATH"
fi

#copy imlib
IMLIB_PATH="../imlib/bin"
if [ -d "$IMLIB_PATH" ]; then
    echo "contact build: copy imlib"
    cp -af ${IMLIB_PATH}/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy imkit
IMKIT_PATH="../imkit/bin"
if [ -d "$IMKIT_PATH" ]; then
    echo "contact build: copy imkit"
    cp -af ${IMKIT_PATH}/* ${CONTACT_FRAMEWORKER_PATH}/
fi
