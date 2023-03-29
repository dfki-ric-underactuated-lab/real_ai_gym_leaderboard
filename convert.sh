#!/bin/bash

# Specify the directory containing the CSV files
csv_dir="."
out_dir="output"

# keep track of processed files
processed_files=()

# Loop over all CSV files in the directory and run the command on them
for csv_file in ${csv_dir}/*.csv; do
  
  # get the file_name
  file_name=$(basename ${csv_file} .csv)

  to_md_cmd="pandoc -s -o $out_dir/$file_name.md -f csv --metadata title=$file_name $csv_file"
  # convert table to md
  echo "Running command: ${to_md_cmd}"
  ${to_md_cmd}
  
  # replace all \ chars to allow for links and some more magic
  sed -i 's/\\\[/\ \[/g' $out_dir/$file_name.md 
  sed -i 's/\\\](/\](/g' $out_dir/$file_name.md 
  sed -i 's/\\\]/\]\ /g' $out_dir/$file_name.md 

  # find matching description.md in root dir, check if it exists. if exists, append it to the md file generated in the last step.
  if [ -e $file_name.md ]; then
    echo "File $file_name has additional md content!" 
    # append newline
    printf "\n" >> $out_dir/$file_name.md
    # append additional md content
    cat $file_name.md >> $out_dir/$file_name.md

  fi


  # convert to html but changing the title
  heading_text_prefix="Welcome\ to\ the\ "
  heading_text=$(echo "$file_name" | sed -e 's/_/\ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${heading_text_prefix}/")
  to_html_cmd="pandoc -s -o $out_dir/$file_name.html --mathjax --standalone --metadata title='"$heading_text"' \
	  --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js $out_dir/$file_name.md"
 

  # Run the command on the current CSV file
  echo "Running command: ${to_html_cmd}"
  echo ${to_html_cmd} | bash

  # add to list of files
  processed_files+=("$file_name")

done

# generate landing page
# convert to html
pandoc -s -o $out_dir/index.html --metadata title="Real AI Gym Leaderboards" --css=static/style.css --template=templates/default.html5 index.md

# in the generated html, search for this string...
placeholder="<p>:::leaderboard-links:::</p>"

# and replace with this...
table="<table>"
for file_name in "${processed_files[@]}"; do
  link_name="${file_name}.html"
  table_text_prefix="> "
  table_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${table_text_prefix} /")
  table+="<tr><td><a href='${link_name}' class='file-link'>${table_text}</a></td></tr>"
done
table+="</table>"

sed -i "s|${placeholder}|${table}|g" $out_dir/index.html

