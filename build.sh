#!/usr/bin/env sh

test -e versions/.DS_Store || rm versions/.DS_Store # Prevent bugs on OSX
declare -a versions
versions=(versions/*)
version_count="${#versions[@]}"
if [ version_count -eq 0 ]; then
  echo "No versions found!"
  exit -1
fi
echo "Select a sourcemod version to build against:"
for (( i=0; i<"$version_count"; i++)); do
  echo "($i) ${versions[$i]}"
done
read i
version="${versions[$i]}"

if [ -z "ls scripting" ]; then
  echo "No source files found!"
else
  for source in scripting/*.sp; do
    if [ $source != ".DS_Store" ]; then
      plugin="$(echo "$source" | sed -e s/^scripting/plugins/ | sed s/sp$/smx/)"
      output="$(./"$version"/spcomp "$source" -o="$plugin" -i=include -i="$version"/include)"
      echo "$output"
      # if line[-3] == "Compilation aborted."
      # print 'Errors for file {source}:'.format(source=source)
          #   if not quiet:
          #     for line in lines[3:-4]:
          #       print line
          #     print '\n'
    fi
  done
fi
