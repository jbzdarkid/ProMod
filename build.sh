#!/usr/bin/env sh

if [ -z "$(ls scripting)" ]; then
  echo "No source files found!"
  exit 1
fi

# Functions {{{1
# verbose() {{{2
verbose() {
  # $1 is the message to be printed
  local message="$1"
  # $2 is the verbosity threshold (default: 1)
  local threshold="${2:-1}"

  if [ "$verbose" -ge "$threshold" ] && [ -z "$quiet" ]; then
    echo "$message" >&2 || return 1
  fi
}
# verbose() 2}}}
# error() {{{2
error() {
  #  is the message to be printed
  local message="$1"

  if [ -z "$quiet" ]; then
    echo "$message" >&2 || return 1
  fi
}
# error() 2}}}
# sp_compile() {{{2
sp_compile() {
  # Compiles a plugin using spcomp
  # $1: path to the spcomp binary
  # $2: path to the source file
  # $3: (optional) output file path

  #{{{3 Arguments
  if [ -z "$1" ]; then
    error "Argument not optional."
    return 1
  elif [ ! -r "$1" ]; then
    error "spcomp not readable or not found at given path: $1"
    return 1
  elif [ ! -x "$1" ]; then
    error "$1 is not executable."
    return 1
  else
    local spcomp_path="$1"
  fi

  if [ -z "$2" ]; then
    error "sp_compile: Argument not optional."
    return 1
  elif [ ! -r "$2" ]; then
    error "sp_compile: Source file not readable or not found."
    return 1
  else
    local source_file="$2"
  fi

  if [ -n "$3" ]; then
    local output_file="-o $3"
  fi
# Arguments 3}}}

  exec "$spcomp_path" "$source_file" "$output_file" \ 
    -i=include \ 
    -i="$(dirname "$spcomp_path")"/include
}
# sp_compile() 2}}}
# Functions 1}}}

for sourcefile in scripting/*.sp; do
  sourcefile="$(echo "$sourcefile" | sed -e 's/^scripting/plugins/' -e 's/sp$/smx/')"
  outputfile="$(basename "$sourcefile".smx)"
  spcompfile="./build/spcomp"

  printf "Compiling %s With %s Into %s\n" "$sourcefile" "$spcompfile" "$outputfile"
  sp_compile "$spcompfile" "$sourcefile" "$outputfile"

done

# vim: ft=sh foldmethod=marker:
