#!/bin/bash

file="labelled_newscatcher_dataset.csv"

usage() {
    echo "Task 1 usage:"
    echo "		-w | --workers I       # workers_number"
    echo "		-s | --source_column I # source_column"
    echo "		-d | --directory S     # folder"
    echo "I - integer, S - string"
}

if ! [[ -f $file ]]; then
    echo "No table found."
    exit 1
fi

while [ $# -gt 0 ]; do
    case $1 in
    -w | --workers)
        workers="$2"
        ;;
    -s | --source_column)
        source_column="$2"
        ;;
    -d | --directory)
        directory="$2"
        ;;
    esac
    shift
done

if [[ -z $directory || -z $workers || -z $directory ]]; then
    echo "Missing argument."
    usage
    exit 1
fi

# Check if workers is integer
if ! [[ $workers =~ ^[0-9]+$ ]]; then
    usage
    exit 1
fi

# Check if column is integer
if ! [[ $source_column =~ ^[0-9]+$ ]]; then
    usage
    exit 1
fi

# Check if column exists
IFS=$';' read -r -a columns <$file
if [[ $source_column > ${#columns[@]} ]]; then
    echo "Requested column is out of range. Files contains only "${#columns[@]}" columns."
    exit 1
fi

parallel -j $workers --skip-first-line --colsep ';' wget -P $directory -q {$source_column} :::: $file
