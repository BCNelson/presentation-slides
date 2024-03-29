#!/usr/bin/env bash
# shellcheck disable=SC2034

###############################################################################
#
# demo-magic.sh
#
# Copyright (c) 2015-2022 Paxton Hare
#
# This script lets you script demos in bash. It runs through your demo script
# when you press ENTER. It simulates typing and runs commands.
#
###############################################################################

# The MIT License (MIT)

# Copyright (c) 2015-2022 Paxton Hare

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# the speed to simulate typing the text
TYPE_SPEED=20

# no wait after "p" or "pe"
NO_WAIT_BEFORE=false
NO_WAIT_AFTER=false

# if > 0, will pause for this amount of seconds before automatically proceeding with any p or pe
PROMPT_TIMEOUT=0

# don't show command number unless user specifies it
SHOW_CMD_NUMS=false


# handy color vars for pretty prompts
BLACK="\033[0;30m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
GREY="\033[0;90m"
CYAN="\033[0;36m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
BROWN="\033[0;33m"
WHITE="\033[0;37m"
BOLD="\033[1m"
COLOR_RESET="\033[0m"

C_NUM=0

# prompt and command color which can be overriden
DEMO_PROMPT="$ "
DEMO_CMD_COLOR=$BOLD
DEMO_COMMENT_COLOR=$GREEN

##
# prints the script usage
##
function usage() {
  echo -e ""
  echo -e "Usage: $0 [options]"
  echo -e ""
  echo -e "  Where options is one or more of:"
  echo -e "  -h  Prints Help text"
  echo -e "  -d  Debug mode. Disables simulated typing"
  echo -e "  -n  No wait"
  echo -e "  -w  Waits max the given amount of seconds before "
  echo -e "      proceeding with demo (e.g. '-w5')"
  echo -e ""
}

##
# wait for user to press ENTER
# if $PROMPT_TIMEOUT > 0 this will be used as the max time for proceeding automatically
##
function wait() {
  if [[ "$PROMPT_TIMEOUT" == "0" ]]; then
    read -rs
  else
    read -rst "$PROMPT_TIMEOUT"
  fi
}

##
# print command only. Useful for when you want to pretend to run a command
#
# takes 1 param - the string command to print
#
# usage: p "ls -l"
#
##
function p() {
  if [[ ${1:0:1} == "#" ]]; then
    cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  else
    cmd=$DEMO_CMD_COLOR$1$COLOR_RESET
  fi

  # render the prompt
  x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')

  # show command number is selected
  if $SHOW_CMD_NUMS; then
   printf "[$((++C_NUM))] %s" "$x"
  else
   printf "%s" "$x"
  fi

  # wait for the user to press a key before typing the command
  if [ $NO_WAIT_BEFORE = false ]; then
    wait
  fi

  check_pv
  if [[ -z $TYPE_SPEED ]]; then
    echo -en "$cmd"
  else
    echo -en "$cmd" | pv -qL $(( TYPE_SPEED+(-2 + RANDOM%5) ));
  fi

  # wait for the user to press a key before moving on
  if [ $NO_WAIT_AFTER = false ]; then
    wait
  fi
  echo ""
}

##
# Prints and executes a command
#
# takes 1 parameter - the string command to run
#
# usage: pe "ls -l"
#
##
function pe() {
  # print the command
  p "$@"
  run_cmd "$@"
}

##
# print and executes a command immediately
#
# takes 1 parameter - the string command to run
#
# usage: pei "ls -l"
#
##
function pei {
  NO_WAIT_BEFORE=true pe "$@"
}

##
# Enters script into interactive mode
#
# and allows newly typed commands to be executed within the script
#
# usage : cmd
#
##
function cmd() {
  # render the prompt
  x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')
  printf "$x\033[0m"
  read command
  run_cmd "${command}"
}

function run_cmd() {
  function handle_cancel() {
    printf ""
  }

  trap handle_cancel SIGINT
  stty -echoctl
  eval "$@"
  stty echoctl
  trap - SIGINT
}


function check_pv() {
  command -v pv >/dev/null 2>&1 || unset TYPE_SPEED
}

#
# handle some default params
# -h for help
# -d for disabling simulated typing
#
while getopts ":dhncw:" opt; do
  case $opt in
    h)
      usage
      exit 1
      ;;
    d)
      unset TYPE_SPEED
      ;;
    n)
      NO_WAIT_BEFORE=true
      NO_WAIT_AFTER=true
      ;;
    c)
      SHOW_CMD_NUMS=true
      ;;
    w)
      PROMPT_TIMEOUT=$OPTARG
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

##
# Do not check for pv. This trusts the user to not set TYPE_SPEED later in the
# demo in which case an error will occur if pv is not installed.
##
if [[ -n "$TYPE_SPEED" ]]; then
  check_pv
fi