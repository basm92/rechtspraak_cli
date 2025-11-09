#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <date1> <date2> [civielRecht yes/no] [output_file]"
    exit 1
fi

# Assign arguments to variables
date1="$1"
date2="$2"
civielRecht="${3:-yes}" # Default to "yes" if not provided
output_file="$4"

# If the third argument is the output file, adjust variables
if [[ "$civielRecht" != "yes" && "$civielRecht" != "no" ]]; then
    output_file="$civielRecht"
    civielRecht="yes"
fi


# Validate the date format using regex
if [[ ! $date1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ || ! $date2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: Dates must be in the format YYYY-MM-DD"
    exit 1
fi

# Base URL
url="https://data.rechtspraak.nl/uitspraken/zoeken?type=uitspraak&date=$date1&date=$date2&return=DOC"

# Add subject parameter if civielRecht is "yes"
if [ "$civielRecht" == "yes" ]; then
    url+="&subject=http://psi.rechtspraak.nl/rechtsgebied%23civielRecht"
fi

# Fetch the data, convert to JSON, and extract IDs
if [ -z "$output_file" ]; then
    curl -s "$url" | xml2json | jq '.[].entry[].id."$t"' | sed 's/"//g'
else
    curl -s "$url" | xml2json | jq '.[].entry[].id."$t"' | sed 's/"//g' > "$output_file"
    echo "Output written to $output_file"
fi
