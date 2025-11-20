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

# Base URL Construction
base_url="https://data.rechtspraak.nl/uitspraken/zoeken?type=uitspraak&date=$date1&date=$date2&return=DOC"

# Add subject parameter if civielRecht is "yes"
if [ "$civielRecht" == "yes" ]; then
    base_url+="&subject=http://psi.rechtspraak.nl/rechtsgebied%23civielRecht"
fi

# Prepare output file (if specified, clear it first)
if [ -n "$output_file" ]; then
    : > "$output_file"
    echo "Fetching data..."
fi

# Pagination Loop
start=0
step=1000 # Rechtspraak API usually batches by 100 or 1000

while true; do
    # Construct the full URL with the 'from' parameter
    current_url="${base_url}&from=${start}"
    
    # Optional: Print progress to stderr so it doesn't pollute stdout results
    >&2 echo "Fetching batch starting at index $start..."

    # Fetch data, convert, and extract. 
    # We use jq -r (raw) to remove quotes automatically.
    # We capture the output into a variable to check if it is empty.
    batch_results=$(curl -s "$current_url" | xml2json | jq -r 'try .[].entry[].id."$t" catch empty')

    # Check if we got any results
    if [ -z "$batch_results" ]; then
        >&2 echo "No more results found. Finished."
        break
    fi

    # Output handling
    if [ -z "$output_file" ]; then
        # Output to console
        echo "$batch_results"
    else
        # Append to file
        echo "$batch_results" >> "$output_file"
    fi

    # Increment the start index
    start=$((start + step))
done

if [ -n "$output_file" ]; then
    echo "Output written to $output_file"
fi
