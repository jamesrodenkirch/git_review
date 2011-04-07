#! /bin/bash
#
# The MIT License
#
# Copyright (c) 2010 James Rodenkirch <james@rodenkirch.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.



#----------------------------------->> make sure parameters are passed in  <<---


if [ $# -eq 0 ] # should check for no arguments
then
    echo "Usage: review.sh [ review|merge ]"
    exit 0
fi

TITLE="Merge Request"
TYPE=$1


#------------------------------------------------>> prompt for parameters  <<---


remotes=`for x in $(git remote); do echo $x "remote"; done`
LOCATION=$(whiptail \
    --title "${TITLE}" \
    --menu "Available Remotes" 10 50 4 ${remotes} 2>&1 >/dev/tty)

if [ $? != 0 ]; then
    exit 0
fi


NUMBER=$(whiptail \
    --title "${TITLE}" \
    --inputbox "Merge Request #" \
    10 50 2>&1 > /dev/tty)

if [ $? != 0 ]; then
    exit 0
fi


#----------------------------------------------------->>  prep git command <<---


case "${TYPE}" in
    'review')
        COMMAND="git pull --no-ff --no-commit ${LOCATION} refs/merge-requests/${NUMBER} && git reset HEAD *"
        ;;
    'merge')
        COMMAND="git pull ${LOCATION} refs/merge-requests/${NUMBER}"
        ;;
esac


#----------------------------------------------------->>  execute command  <<---


eval "${COMMAND}"
exit 0
