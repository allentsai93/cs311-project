#!/bin/bash

if [ -z "$1" ]; then
    echo "usage handin.sh CS_UGRAD_ID"
    exit 1
fi

COURSE=cs311
ASSN=project-proposal

REMOTE_USER=$1
REMOTE_USER_FIRST_LETTER="$(echo $1 | head -c 1)"
REMOTE_DIR=/home/$REMOTE_USER_FIRST_LETTER/$REMOTE_USER/$COURSE/$ASSN/
REMOTE_HOST=lulu.ugrad.cs.ubc.ca
HANDIN_CMD=/cs/local/bin/handin

LOCAL_FILES=`pwd`/*

ssh -t $REMOTE_USER@$REMOTE_HOST bash -c "'
    mkdir -p $REMOTE_DIR
'"

for f in $LOCAL_FILES; do
    if [[ $f == *"handin"* ]]; then continue; fi
    REMOTE_PATH=$REMOTE_DIR`printf '%s\n' "${f##*/}"`
    scp -p $f $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH
done

ssh -t $REMOTE_USER@$REMOTE_HOST bash -c "'
    $HANDIN_CMD       $COURSE $ASSN
    $HANDIN_CMD -p -o $COURSE $ASSN
    $HANDIN_CMD -c    $COURSE $ASSN
'"
