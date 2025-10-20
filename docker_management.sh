#!/bin/bash
# @name: docker_management.sh
# @creation_date: 2024-09-18
# @license: The MIT License <https://opensource.org/licenses/MIT>
# @author: Simon Bowie <simon.bowie.19@gmail.com>
# @purpose: script for Docker management functions
# @acknowledgements:

############################################################
# variables                                                #
############################################################

DOCKER="/usr/bin/docker"
declare -a DOCKER_CONTAINERS=(
	"calibre"
	"flask" 
	"ghost" 
	"goaccess" 
	"joplin" 
	"php" 
	"podfetch" 
	"sandstorm" 
	"tor" 
	"wordpress" 
	"nginx"
)

############################################################
# subprograms                                              #
############################################################

License()
{
  echo 'Copyright 2024 Simon Bowie <simon.bowie.19@gmail.com>'
  echo
  echo 'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:'
  echo
  echo 'The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.'
  echo
  echo 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'
}

Help()
{
   # Display Help
   echo "This script performs Docker management functions for this server"
   echo
   echo "Syntax: docker_management.sh [-l|h|s|t|r]"
   echo "options:"
   echo "l     Print the MIT License notification."
   echo "h     Print this Help."
   echo "s     Stop all Docker Compose stacks."
   echo "t     Start all Docker Compose stacks."
   echo "r     Restart all Docker Compose stacks."
   echo
}

Stop()
{
   # Stop all Docker Compose stacks
   for i in "${DOCKER_CONTAINERS[@]}"
   do
	cd /home/simonxix/docker/$i
	$DOCKER compose down
   done
} 

Start()
{
   # Start all Docker Compose stacks
   for i in "${DOCKER_CONTAINERS[@]}"
   do
        cd /home/simonxix/docker/$i
        $DOCKER compose up -d
   done
}

############################################################
############################################################
# main program                                             #
############################################################
############################################################

# error message for no flags
if (( $# == 0 )); then
    Help
    exit 1
fi

# get the options
while getopts ":hlstr" flag; do
   case $flag in
      l) # display License
        License
        exit;;
      h) # display Help
        Help
        exit;;
      s) # stop all Docker Compose stacks
	Stop
	exit;;
      t) # start all Docker Compose stacks
        Start
        exit;;
      r) # restart all Docker Compose stacks
        Stop
	Start
        exit;;
      \?) # Invalid option
        Help
        exit;;
   esac
done

