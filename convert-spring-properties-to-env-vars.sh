#!/usr/bin/env bash
# convert-spring-properties-to-env-vars.sh
# Greg Trout | grtrout@gmail.com

convert_key() {
  UPPERCASE_KEY=$(echo ${1} | tr "[:lower:]" "[:upper:]")
  DASH_REMOVED_KEY=$(echo "${UPPERCASE_KEY//-}")
  FINAL_KEY="${DASH_REMOVED_KEY//[^A-Za-z0-9]/_}"
}

while IFS='' read -r LINE || [ -n "${LINE}" ]; do
  [[ "${LINE}" =~ ^[[:space:]]*# ]] && continue  # Ignore comments
  if [ -n "${LINE}" ]; then
    KEY_ONLY=${LINE%=*}  # Delete from = to the right
    VALUE_ONLY=${LINE#*=}  # Delete up to =
    convert_key ${KEY_ONLY}
    echo "${FINAL_KEY}: '${VALUE_ONLY}'"
  fi
done <${1}

