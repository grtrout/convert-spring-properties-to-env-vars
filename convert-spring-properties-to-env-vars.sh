#!/usr/bin/env bash
# convert-spring-properties-to-env-vars.sh
# Greg Trout | grtrout@gmail.com

convert_key() {
  local NEW_KEY="$(echo ${1} | tr "[:lower:]" "[:upper:]")" # Convert to uppercase
  NEW_KEY="$(echo "${NEW_KEY//-/}")" # Remove dashes
  KEY="${NEW_KEY//[^[:alnum:]]/_}"   # Convert other non-alphanumeric chars to underscores
}

convert_value() {
  local NEW_VALUE="${1#"${1%%[![:space:]]*}"}"           # Trim leading spaces
  NEW_VALUE="${NEW_VALUE%"${NEW_VALUE##*[![:space:]]}"}" # Trim trailing spaces

  local FIRST_CHAR="${NEW_VALUE:0:1}" # Determine first character
  local LAST_CHAR="${NEW_VALUE: -1}"  # Determine last character

  if ([[ ${FIRST_CHAR} = ${LAST_CHAR} ]]) && ([[ ${FIRST_CHAR} = \' || ${FIRST_CHAR} = \" ]]); then
    VALUE="${NEW_VALUE}" # Variable already surrounded with single or double quotes; leave as-is
  else
    VALUE="\"${NEW_VALUE}\"" # Surround variable with double quotes
  fi
}

while IFS='' read -r LINE || [[ -n ${LINE} ]]; do # Loop through each line of input file
  [[ ${LINE} =~ ^[[:space:]]*# ]] && continue     # Ignore comments
  if [[ -n ${LINE} ]]; then
    KEY="${LINE%=*}"   # Delete from = to the right
    VALUE="${LINE#*=}" # Delete up to =
    convert_key "${KEY}"
    convert_value "${VALUE}"
    echo "${KEY}: ${VALUE}" # Send output to stdout
  fi
done <${1}
