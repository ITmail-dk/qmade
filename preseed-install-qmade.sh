#!/bin/sh

USER_HOME=$(grep ":1000:" /etc/passwd | cut -d: -f6) 
NEW_USERNAME=$(grep ":1000:" /etc/passwd | cut -d: -f1)

touch $USER_HOME/first-test.txt