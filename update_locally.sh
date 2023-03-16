mkdir -p output

pandoc -s -o output/index.html -f csv --metadata title="🦾 Real AI Test Leaderboard 🦿" --css=static/style.css --template=templates/default.html5 --include-after=static/style_tables.js leaderboard.csv

cp -p -R static output/
