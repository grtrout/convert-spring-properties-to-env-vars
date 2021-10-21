#!/usr/bin/env bash
# convert-spring-properties-to-env-vars.sh
# Greg Trout | grtrout@gmail.com

convert_key() {
  local UPPERCASED=$(echo ${1} | tr "[:lower:]" "[:upper:]")
  local DASHES_REMOVED=$(echo "${UPPERCASED//-/}")
  KEY="${DASHES_REMOVED//[^[:alnum:]]/_}" # Convert non-alphanumeric chars to underscores
}

convert_value() { # Trim leading and trailing spaces
  local TRIMMED_LEADING="${1#"${1%%[![:space:]]*}"}"
  local TRIMMED_TRAILING="${TRIMMED_LEADING%"${TRIMMED_LEADING##*[![:space:]]}"}"
  VALUE=$TRIMMED_TRAILING
}

while IFS='' read -r LINE || [ -n "${LINE}" ]; do
  [[ "${LINE}" =~ ^[[:space:]]*# ]] && continue # Ignore comments
  if [ -n "${LINE}" ]; then
    KEY=${LINE%=*}   # Delete from = to the right
    VALUE=${LINE#*=} # Delete up to =
    convert_key ${KEY}
    convert_value ${VALUE}
    echo "${KEY}: \"${VALUE}\"" # Echo output to stdout
  fi
done <${1}

