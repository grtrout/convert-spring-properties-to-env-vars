#!/usr/bin/env bash
# convert-spring-properties-to-env-vars.sh
# Greg Trout | grtrout@gmail.com

convert_key() {
  # Capitalize key and remove dashes
  local NEW_KEY="$(echo ${1} | tr "[:lower:]" "[:upper:]")"
  NEW_KEY="$(echo "${NEW_KEY//-/}")"
  KEY="${NEW_KEY//[^[:alnum:]]/_}" # Convert non-alphanumeric chars to underscores
}

convert_value() {
  # Trim leading and trailing spaces
  local NEW_VALUE="${1#"${1%%[![:space:]]*}"}"
  NEW_VALUE="${NEW_VALUE%"${NEW_VALUE##*[![:space:]]}"}"

  # Determine first and last char of value
  local FIRST_CHAR="${NEW_VALUE:0:1}"
  local LAST_CHAR="${NEW_VALUE: -1}"

  # Only add double quotes around value if it's not already surrounded by single or double quotes
  if ([[ ${FIRST_CHAR} = ${LAST_CHAR} ]]) && ([[ ${FIRST_CHAR} = \' || ${FIRST_CHAR} = \" ]]); then
    VALUE="${NEW_VALUE}"
  else
    VALUE="\"${NEW_VALUE}\""
  fi
}

# Loop through each line of input file
while IFS='' read -r LINE || [[ -n ${LINE} ]]; do
  [[ ${LINE} =~ ^[[:space:]]*# ]] && continue # Ignore comments
  if [[ -n ${LINE} ]]; then
    KEY="${LINE%=*}"   # Delete from = to the right
    VALUE="${LINE#*=}" # Delete up to =
    convert_key ${KEY}
    convert_value ${VALUE}
    echo "${KEY}: ${VALUE}" # Echo output to stdout
  fi
done <${1}
