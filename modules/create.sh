#!/bin/bash

read -p "Enter table name: " tbName

# Check if no table name was entered
if [ -z "$tbName" ]; then
    echo "Error: No table name you entered" 
    exit 1
fi

# Check if the table file already exists
if [ -f "./Tables/$tbName" ]; then
    echo "Error: This table already exists"
    exit 1
fi

if ! [[ $tbName =~ ^[a-zA-Z0-9] ]]; then
    echo " #### Table name Must start with string"
    exit 1
fi

# Read column names and store it into arry (-a) named cols
read -p "Enter the names of columns separated by spaces: " -a cols

# Check the length of array [ #cols[@] == in python len(cols) ]
if [ ${#cols[@]} -eq 0 ]; then
    echo "#### No columns specified"
    exit 1
fi

# Read data types for columns
read -p "Enter the data type for each column respectively separated by spaces (s:string / i:integer): " -a datatypes

# Check if data types specified for all columns
if [ ${#datatypes[@]} -ne ${#cols[@]} ]; then
    echo "#### Data types must be specified for all columns"
    exit 1
fi

# Read primary key specification for columns
read -p "Specify which column is primary (primary:p / normal:n): " -a primaryKey

# Check if primary key specification was provided for all columns
if [ ${#primaryKey[@]} -ne ${#cols[@]} ]; then
    echo "#### Primary key specification must be provided for all columns"
    exit 1
fi

valid=1

# Check the validity of data types and primary key specifications
for i in "${datatypes[@]}"; do
	# convert i to upper case to match to S for string or I for Integer
    if ! [[ ${i^^} =~ ^(S|I)$ ]]; then
        echo "#### One or more data types is invalid"
        valid=0
        break
    fi
done

primaryCount=0

for i in "${primaryKey[@]}"; do
    if ! [[ ${i^^} =~ ^(P|N)$ ]]; then
        echo "#### One or more column types (p/n) is invalid"
        valid=0
        break
    fi

    if [[ ${i^^} = "P" ]]; then
        primaryCount=$((primaryCount + 1))
    fi
done

# Check for primary key constraints
if [ $valid -eq 1 ]; then
    if [ $primaryCount -gt 1 ]; then
        echo "#### Cannot set up more than one primary key column" 
        exit 1
    elif [ $primaryCount -eq 0 ]; then
        echo "#### There must be one primary key column"
        exit 1
    fi

    # Create the table file and metadata
    touch "./Tables/$tbName" "./Metadata/$tbName"
    echo "Table $tbName created"

    for ((i = 0; i < ${#cols[@]}; i++)); do
        echo "${cols[$i]}:${datatypes[$i]}:${primaryKey[$i]}" >> "./Metadata/$tbName"
    done
fi

