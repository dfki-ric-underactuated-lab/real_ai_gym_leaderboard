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
echo "<head>" >> "${html_file}"
echo "<link rel='stylesheet' href='static/style.css'>" >> "${html_file}"
echo "<style>" >> "${html_file}"
echo ".outer { display: flex; justify-content: center; align-items: center; height: 100vh; }" >> "${html_file}"
echo ".heading { text-align: center; }" >> "${html_file}"
echo ".file-list { margin-left: auto; margin-right: auto; }" >> "${html_file}"
echo ".file-link { font-weight: bold; }" >> "${html_file}"
echo "</style>" >> "${html_file}"
echo "</head>" >> "${html_file}"
echo "<body>" >> "${html_file}"
echo "<div class='outer'>" >> "${html_file}"
echo "<div class='inner'>" >> "${html_file}"
#echo "<h2 class='heading'>List of Processed Files</h2>" >> "${html_file}"
echo "<h2 class='heading'>🦾 Real AI Leaderboards 🦿</h2>" >> "${html_file}"
echo "<table class='file-list'>" >> "${html_file}"
for file_name in "${processed_files[@]}"; do
  link_name="${file_name}.html"
  echo "<tr><td><a href='${link_name}' class='file-link'>${file_name}</a></td></tr>" >> "${html_file}"
done
echo "</table>" >> "${html_file}"
echo "</div>" >> "${html_file}"
echo "</div>" >> "${html_file}"
echo "</body>" >> "${html_file}"
echo "</html>" >> "${html_file}"
echo "List of processed files written to: ${html_file}"

