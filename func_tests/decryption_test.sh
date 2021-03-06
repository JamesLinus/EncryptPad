#!/bin/sh
set -e
USAGE1="decryption_test.sh <path_to_decryptor> <directory_with_encrypted_files>"
USAGE2="path_to_decryptor - path to encrypt_cli or gpg"
if [ $# -lt 2 ]
then
    echo $USAGE1
    echo $USAGE2
    exit 1
fi

DECRYPTOR="$1"
IN_DIR="$2"
TMP_DIR="./tmp"
PASSPHRASE_FILE="passphrase.txt"

mkdir -p $TMP_DIR

RESULT=0

for FILE in ${IN_DIR}/*
do
    if [ $DECRYPTOR = "gpg" ]
    then
        gpg -d --no-use-agent --passphrase-file $PASSPHRASE_FILE -o $TMP_DIR/out_file.txt $FILE
    else
        $DECRYPTOR -d -p $PASSPHRASE_FILE -o $TMP_DIR/out_file.txt $FILE
    fi

    if ! [ -r $TMP_DIR/out_file.txt ]
    then
        continue
    fi

    if diff plain_text.txt $TMP_DIR/out_file.txt
    then
        echo ok
    else
        RESULT=1
        echo fail
    fi
    rm $TMP_DIR/out_file.txt
done

rm -R $TMP_DIR
exit $RESULT
