#!/bin/bash

# Check if the filename argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Get the filename from the command line argument
filename="$1"

# Check if the file exists
if [ -f "$filename" ]; then
    # Parse the JSON file to count the number of vulnerabilities
    num_vulnerabilities=$(jq -r '.vulnerabilities | length' "$filename")

    # Check if the number of vulnerabilities is greater than or equal to 2
    if [ "$num_vulnerabilities" -ge 0 ]; then
        echo "Aborting pipeline due to $num_vulnerabilities vulnerabilities."
        exit 80
    else
        echo "Pipeline continues with $num_vulnerabilities vulnerabilities."
    fi
else
    echo "JSON file $filename not found or inaccessible."
    exit 80
fi
