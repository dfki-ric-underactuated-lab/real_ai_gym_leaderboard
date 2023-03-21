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

  # Specify the command to run on each CSV file
  command_to_run="pandoc -s -o $out_dir/$file_name.html -f csv --metadata title=$file_name --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js"
  
  # Run the command on the current CSV file
  echo "Running command: ${command_to_run} ${csv_file}"
  ${command_to_run} ${csv_file}

  # add to list of files
  processed_files+=("$file_name")

done

# generate quick and dirty landing page
html_file="$out_dir/index.html"
echo "<html>" > "${html_file}"
echo "<body>" >> "${html_file}"
echo "<h2 style='text-align:center'>List of Processed Files</h2>" >> "${html_file}"
echo "<div style='text-align:center'>" >> "${html_file}"
for file_name in "${processed_files[@]}"; do
  link_name="${file_name}.html"
  echo "<a href='${link_name}'>${file_name}</a><br>" >> "${html_file}"
done
echo "</div>" >> "${html_file}"
echo "</body>" >> "${html_file}"
echo "</html>" >> "${html_file}"
echo "List of processed files written to: ${html_file}"
