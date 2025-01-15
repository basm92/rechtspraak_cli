#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_folder>"
    exit 1
fi

# Assign arguments to variables
input_file="$1"
output_folder="$2"

# Validate the input file
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 1
fi

# Create the output folder if it does not exist
if [ ! -d "$output_folder" ]; then
    mkdir -p "$output_folder"
fi

# Process each line in the input file
while IFS= read -r id; do
    # Skip empty lines
    if [ -z "$id" ]; then
        continue
    fi

    # Define the output file name
    output_file="$output_folder/$id.xml"

    # Fetch the XML document and save it
    curl -s "https://data.rechtspraak.nl/uitspraken/content?id=$id" -o "$output_file"
    
    echo "Saved XML for ID $id to $output_file"
done < "$input_file"

echo "Processing complete. XML files are saved in '$output_folder'."

