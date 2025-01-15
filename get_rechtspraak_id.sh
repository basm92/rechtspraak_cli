#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <date1> <date2> [output_file]"
    exit 1
fi

# Assign arguments to variables
date1="$1"
date2="$2"
output_file="$3"

# Validate the date format using regex
if [[ ! $date1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ || ! $date2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: Dates must be in the format YYYY-MM-DD"
    exit 1
fi

# URL with substituted dates
url="https://data.rechtspraak.nl/uitspraken/zoeken?type=conclusie&date=$date1&date=$date2"

# Fetch the data, convert to JSON, and extract IDs
if [ -z "$output_file" ]; then
    curl -s "$url" | xml2json | jq '.[].entry[].id."$t"' | sed 's/"//g'
else
    curl -s "$url" | xml2json | jq '.[].entry[].id."$t"' | sed 's/"//g' > "$output_file"
    echo "Output written to $output_file"
fi

