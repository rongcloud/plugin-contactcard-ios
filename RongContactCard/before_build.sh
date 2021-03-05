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

#copy imlibcore
IMLIBCORE_PATH="../imlibcore"
if [ -d ${IMLIBCORE_PATH}/ ]; then
   echo "contact build: copy imlibcore"
   cp -af ${IMLIBCORE_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy chatroom
CHATROOM_PATH="../chatroom"
if [ -d ${CHATROOM_PATH}/bin ]; then
   echo "contact build: copy chatroom"
   cp -af ${CHATROOM_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy discussion
DISCUSSION_PATH="../discussion"
if [ -d ${DISCUSSION_PATH}/bin ]; then
   echo "contact build: copy discussion"
   cp -af ${DISCUSSION_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy publicservice
PUBLICSERVICE_PATH="../publicservice"
if [ -d ${PUBLICSERVICE_PATH}/bin ]; then
   echo "contact build: copy publicservice"
   cp -af ${PUBLICSERVICE_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy customerservice
CUSTOMERSERVICE_PATH="../customerservice"
if [ -d ${CUSTOMERSERVICE_PATH}/bin ]; then
   echo "contact build: copy customerservice"
   cp -af ${CUSTOMERSERVICE_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi

#copy location
REALTIMELOCATION_PATH="../location"
if [ -d ${REALTIMELOCATION_PATH}/bin ]; then
   echo "contact build: copy location"
   cp -af ${REALTIMELOCATION_PATH}/bin/* ${CONTACT_FRAMEWORKER_PATH}/
fi
