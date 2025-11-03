#!/bin/bash

files=$(find ./dcmac_0_ex -name "dcmac*.c")

echo ${files}

for file in $files; do
	# Get just the filename, without path
	echo ${file}
  filename=$(basename "$file")
  echo ${filename}
  echo ${filename%.c}
  # Apply the changes and save to the current directory
  sed "/main()/i /*" "$file" | sed "\$a */" > "./${filename%.c}_lib.h"
done

#sed '/main()/i /*' filename | sed '$a */' > newfile
