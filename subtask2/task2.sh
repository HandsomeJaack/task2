#!/bin/bash

usage() {
    echo "Task 2 usage:"
    echo "		--input S       # path to dataset"
    echo "		--train_ratio I # percentage of objects in train sample"
    echo "I - integer, S - string"
}

while [ $# -gt 0 ]; do
    case $1 in
    --input)
        file="$2"
        ;;
    --ratio)
        ratio="$2"
        ;;
    esac
    shift
done

if [[ -z $file || -z $ratio ]]; then
    echo "Missing argument."
    usage
    exit 1
fi

if ! [[ -f $file ]]; then
    echo "No dataset found."
    exit 1
fi

# Check if train ratio is integer
if ! [[ $ratio =~ ^[0-9]+$ ]]; then
    usage
    exit 1
fi

if [[ $ratio -gt 100 ]]; then
    echo "Ratio is bigger tha 100%."
    exit 1
fi

lines_in_dataset=$(wc -l <$file)
train_lines_number=$(expr $lines_in_dataset \* $ratio / 100)

tail -n +2 $file | head -n $(expr $train_lines_number - 1) >train.csv
tail -n +$(expr $train_lines_number + 1) $file >validate.csv
