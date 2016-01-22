#!/usr/bin/env sh

quiet=0
if [ $# -gt 0 ] && [ "$1" = "-q" ]; then
  quiet=1
fi
if [ -z "$(ls scripting)" ]; then
  echo "No source files found!"
  exit 1
fi

for source in scripting/*.sp; do
  plugin="$(echo "$source" | sed -e 's/^scripting/plugins/' | sed 's/sp$/smx/')"
  IFS=$'\n' read -d '' -ra output <<< "$(./build/spcomp "$source" -o="$plugin" -i=include -i=build/include)"
  lines=${#output[@]}

  if [ "${output[(($lines-2))]}" == "Compilation aborted." ]; then
    if [ $quiet -eq 1 ]; then
      printf 'Fatal error in %s\n' "$source"
    else
      for ((i=2; i<$lines-2; i++)); do
          echo "${output[$i]}"
        done
      fi
  elif [[ ${output[(($lines-1))]} =~ Error?s\.$ ]]; then
    if [ $quiet -eq 1 ]; then
      printf 'Error in %s\n' "$source"
    else
      for ((i=2; i<$lines-2; i++)); do
        echo "${output[$i]}"
      done
    fi
  elif [ $lines -gt 7 ]; then
    if [ $quiet -eq 1 ]; then
      printf 'Warning in %s\n' "$source"
    else
      for ((i=2; i<$lines-5; i++)); do
        echo "${output[$i]}"
      done
    fi
  fi
done
