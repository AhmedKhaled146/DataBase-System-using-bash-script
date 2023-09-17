#!/usr/bin/bash

read -p "Enter table name: " tbName

# Check if the table file exists
if [ -f "./Tables/$tbName" ]; then
    read -p "Are you sure? [y/n]: " confirm

    # Convert the user's input to uppercase
    confirm="${confirm^^}"

    if [ "$confirm" = "Y" ]; then
        # Remove the table file and metadata
        rm "./Tables/$tbName"
        rm "./Metadata/$tbName"
        echo "Table $tbName Dropped"
    else
        echo "Table $tbName Not Dropped"
    fi
else
    echo "#### Table $tbName does not exist"
fi

