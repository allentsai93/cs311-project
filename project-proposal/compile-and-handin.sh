#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: compile-and-handin.sh CS_UGRAD_ID"
    exit 1
fi

COURSE=cs311
ASSN=${PWD##*/}

PANDOC_CMD=/usr/local/bin/pandoc

if [ -f $PANDOC_CMD ]; then
    echo "compiling Markdown to PDF"
    $PANDOC_CMD --latex-engine=xelatex -i ./$ASSN.md -o ./$ASSN.pdf
else
    echo "$PANDOC_CMD not found; not compiling Markdown to PDF"
fi

REMOTE_USER=$1
REMOTE_USER_FIRST_LETTER="$(echo $1 | head -c 1)"
REMOTE_DIR=/home/$REMOTE_USER_FIRST_LETTER/$REMOTE_USER/$COURSE/$ASSN/
REMOTE_HOST=lulu.ugrad.cs.ubc.ca
HANDIN_CMD=/cs/local/bin/handin

LOCAL_FILES=`pwd`/*

ssh -t $REMOTE_USER@$REMOTE_HOST bash -c "'
    rm -rf   $REMOTE_DIR
    mkdir -p $REMOTE_DIR
'"

for f in $LOCAL_FILES; do
    if [[ $f == *"handin"* ]]; then continue; fi # Skip copying handin script
    if [[ $f == *".md"*    ]]; then continue; fi # Skip copying Markdown files
    REMOTE_PATH=$REMOTE_DIR`printf '%s\n' "${f##*/}"`
    scp -p $f $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH
done

ssh -t $REMOTE_USER@$REMOTE_HOST bash -c "'
    echo $HANDIN_CMD       $COURSE $ASSN running handin for the first time
         $HANDIN_CMD       $COURSE $ASSN
    echo ===================================================================================================
    echo $HANDIN_CMD -p -o $COURSE $ASSN overwriting previous handin submission
         $HANDIN_CMD -p -o $COURSE $ASSN
    echo ===================================================================================================
    echo $HANDIN_CMD -c    $COURSE $ASSN checking files that were handed in
         $HANDIN_CMD -c    $COURSE $ASSN
'"
