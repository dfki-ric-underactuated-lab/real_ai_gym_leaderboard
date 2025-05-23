#!/bin/bash

# Specify the directory containing the CSV files
csv_dir="leaderboards"
archived_csv_dir="archived_leaderboards"
iros2024_csv_dir="leaderboards/iros2024"
icra2025_csv_dir="leaderboards/icra2025"
out_dir="output"

#########################
# Regular leaderboards
#########################

# keep track of processed files
processed_files_v1=()

# Loop over all *_leaderboard.csv files in the directory and run the command on them
for csv_file in ${csv_dir}/*.csv; do

    # get the file_name
    file_name=$(basename ${csv_file} .csv)

    to_md_cmd="pandoc -s -o $out_dir/$file_name.md -f csv --metadata title=$file_name $csv_file"
    # convert table to md
    echo "Running command: ${to_md_cmd}"
    ${to_md_cmd}

    # replace all \ chars to allow for links and some more magic
    sed -i 's/\\\](/\](/g' $out_dir/$file_name.md
    sed -i 's/\\\]/\]/g' $out_dir/$file_name.md
    sed -i 's/\\\[/\  \[/g' $out_dir/$file_name.md

    # find matching description.md in root dir, check if it exists. if exists, append it to the md file generated in the last step.
    if [ -e ${csv_dir}/$file_name.md ]; then
        echo "File $file_name has additional md content!"
        # append newline
        printf "\n" >>$out_dir/$file_name.md
        # append additional md content
        cat ${csv_dir}/$file_name.md >>$out_dir/$file_name.md

    fi

    # convert to html but changing the title
    # heading_text_prefix="Welcome\ to\ the\ "
    heading_text_prefix=""
    heading_text=$(echo "$file_name" | sed -e 's/_/\ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${heading_text_prefix}/")
    to_html_cmd="pandoc -s -o $out_dir/$file_name.html --mathjax --standalone --metadata title='"$heading_text"' \
	  --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js $out_dir/$file_name.md"

    # Run the command on the current CSV file
    echo "Running command: ${to_html_cmd}"
    echo ${to_html_cmd} | bash

    # add to list of files
    processed_files_v1+=("$file_name")

done

# generate landing page
# convert to html
pandoc -s -o $out_dir/index.html --metadata title="Real AI Gym Leaderboards" --css=static/style.css --template=templates/default.html5 index.md

# in the generated html, search for this string...
placeholder="<p>:::leaderboard-links:::</p>"

# and replace with this...
table="<ul>"
for file_name in "${processed_files_v1[@]}"; do
    link_name="${file_name}.html"
    table_text_prefix=""
    table_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${table_text_prefix} /")
    table+="<li><a href='${link_name}' class='file-link'>${table_text}</a></li>"
done
table+="</ul>"

sed -i "s|${placeholder}|${table}|g" $out_dir/index.html

#########################
# Archived leaderboards
#########################

# repeat the same for all leaderboard_v2.csv files
# keep track of processed files
processed_files_v2=()

# Loop over all *_leaderboard.csv files in the directory and run the command on them
for csv_file in ${archived_csv_dir}/*.csv; do

    # get the file_name
    file_name=$(basename ${csv_file} .csv)

    to_md_cmd="pandoc -s -o $out_dir/$file_name.md -f csv --metadata title=$file_name $csv_file"
    # convert table to md
    echo "Running command: ${to_md_cmd}"
    ${to_md_cmd}

    # replace all \ chars to allow for links and some more magic
    sed -i 's/\\\](/\](/g' $out_dir/$file_name.md
    sed -i 's/\\\]/\]/g' $out_dir/$file_name.md
    sed -i 's/\\\[/\  \[/g' $out_dir/$file_name.md

    # find matching description.md in root dir, check if it exists. if exists, append it to the md file generated in the last step.
    if [ -e ${archived_csv_dir}/$file_name.md ]; then
        echo "File $file_name has additional md content!"
        # append newline
        printf "\n" >>$out_dir/$file_name.md
        # append additional md content
        cat ${archived_csv_dir}/$file_name.md >>$out_dir/$file_name.md

    fi

    # convert to html but changing the title
    # heading_text_prefix="Welcome\ to\ the\ "
    heading_text_prefix=""
    heading_text=$(echo "$file_name" | sed -e 's/_/\ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${heading_text_prefix}/")
    to_html_cmd="pandoc -s -o $out_dir/$file_name.html --mathjax --standalone --metadata title='"$heading_text"' \
	  --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js $out_dir/$file_name.md"

    # Run the command on the current CSV file
    echo "Running command: ${to_html_cmd}"
    echo ${to_html_cmd} | bash

    # add to list of files
    processed_files_v2+=("$file_name")

done

# in the generated html, search for this string...
placeholder_v2="<p>:::archived-leaderboard-links:::</p>"

# and replace with this...
table="<ul>"
for file_name in "${processed_files_v2[@]}"; do
    link_name="${file_name}.html"
    table_text_prefix=""
    table_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${table_text_prefix} /")
    table+="<li><a href='${link_name}' class='file-link'>${table_text}</a></li>"
done
table+="</ul>"

sed -i "s|${placeholder_v2}|${table}|g" $out_dir/index.html

#########################
# IROS 2024 leaderboards
#########################

# keep track of processed files
processed_files_v3=()

# Loop over all *_leaderboard.csv files in the directory and run the command on them
for csv_file in ${iros2024_csv_dir}/*.csv; do

    # get the file_name
    file_name=$(basename ${csv_file} .csv)

    to_md_cmd="pandoc -s -o $out_dir/$file_name.md -f csv --metadata title=$file_name $csv_file"
    # convert table to md
    echo "Running command: ${to_md_cmd}"
    ${to_md_cmd}

    # replace all \ chars to allow for links and some more magic
    sed -i 's/\\\](/\](/g' $out_dir/$file_name.md
    sed -i 's/\\\]/\]/g' $out_dir/$file_name.md
    sed -i 's/\\\[/\  \[/g' $out_dir/$file_name.md

    # find matching description.md in root dir, check if it exists. if exists, append it to the md file generated in the last step.
    if [ -e ${iros2024_csv_dir}/$file_name.md ]; then
        echo "File $file_name has additional md content!"
        # append newline
        printf "\n" >>$out_dir/$file_name.md
        # append additional md content
        cat ${iros2024_csv_dir}/$file_name.md >>$out_dir/$file_name.md

    fi

    # convert to html but changing the title
    # heading_text_prefix="Welcome\ to\ the\ "
    heading_text_prefix=""
    heading_text=$(echo "$file_name" | sed -e 's/_/\ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${heading_text_prefix}/")
    to_html_cmd="pandoc -s -o $out_dir/$file_name.html --mathjax --standalone --metadata title='"$heading_text"' \
	  --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js $out_dir/$file_name.md"

    # Run the command on the current CSV file
    echo "Running command: ${to_html_cmd}"
    echo ${to_html_cmd} | bash

    # add to list of files
    processed_files_v3+=("$file_name")

done

# in the generated html, search for this string...
placeholder_v3="<p>:::iros2024-leaderboard-links:::</p>"

# and replace with this...
table="<ul>"
for file_name in "${processed_files_v3[@]}"; do
    link_name="${file_name}.html"
    table_text_prefix=""
    table_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${table_text_prefix} /")
    table+="<li><a href='${link_name}' class='file-link'>${table_text}</a></li>"
done
table+="</ul>"

sed -i "s|${placeholder_v3}|${table}|g" $out_dir/index.html

#########################
# ICRA 2025 leaderboards
#########################

# keep track of processed files
processed_files_v4=()

# Loop over all *_leaderboard.csv files in the directory and run the command on them
for csv_file in ${icra2025_csv_dir}/*.csv; do

    # get the file_name
    file_name=$(basename ${csv_file} .csv)

    to_md_cmd="pandoc -s -o $out_dir/$file_name.md -f csv --metadata title=$file_name $csv_file"
    # convert table to md
    echo "Running command: ${to_md_cmd}"
    ${to_md_cmd}

    # replace all \ chars to allow for links and some more magic
    sed -i 's/\\\](/\](/g' $out_dir/$file_name.md
    sed -i 's/\\\]/\]/g' $out_dir/$file_name.md
    sed -i 's/\\\[/\  \[/g' $out_dir/$file_name.md

    # find matching description.md in root dir, check if it exists. if exists, append it to the md file generated in the last step.
    if [ -e ${icra2025_csv_dir}/$file_name.md ]; then
        echo "File $file_name has additional md content!"
        # append newline
        printf "\n" >>$out_dir/$file_name.md
        # append additional md content
        cat ${icra2025_csv_dir}/$file_name.md >>$out_dir/$file_name.md

    fi

    # convert to html but changing the title
    # heading_text_prefix="Welcome\ to\ the\ "
    heading_text_prefix=""
    heading_text=$(echo "$file_name" | sed -e 's/_/\ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${heading_text_prefix}/")
    to_html_cmd="pandoc -s -o $out_dir/$file_name.html --mathjax --standalone --metadata title='"$heading_text"' \
	  --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js $out_dir/$file_name.md"

    # Run the command on the current CSV file
    echo "Running command: ${to_html_cmd}"
    echo ${to_html_cmd} | bash

    # add to list of files
    processed_files_v4+=("$file_name")

done

# in the generated html, search for this string...
placeholder_v4="<p>:::icra2025-leaderboard-links:::</p>"

# and replace with this...
table="<ul>"
for file_name in "${processed_files_v4[@]}"; do
    link_name="${file_name}.html"
    table_text_prefix=""
    table_text=$(echo "$file_name" | sed -e 's/_/ /g' -e 's/\b\(.\)/\u\1/g' -e "s/^/${table_text_prefix} /")
    table+="<li><a href='${link_name}' class='file-link'>${table_text}</a></li>"
done
table+="</ul>"

sed -i "s|${placeholder_v4}|${table}|g" $out_dir/index.html
