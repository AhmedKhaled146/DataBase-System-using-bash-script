#!/usr/bin/bash

read -p "Enter Table Name: " tbName
read -p "Enter the primary key value of the row to delete: " val

# Check if the table exists and required files exist

if [ -n "$tbName" ] && [ -f "./Tables/$tbName" ] && [ -f "./Metadata/$tbName" ]; then

    # Get the primary key (:p) column number [-n ==> to include line numbers]
    
    colNo=$(grep -n ":p$" "./Metadata/$tbName" | cut -d: -f1)

    # Check if the given value exists in the table
    
    rowNumber=$(grep -n "^$val:" "./Tables/$tbName" | cut -d: -f1)

    # If the row exists, delete it; otherwise, return an error
    
    if [ -n "$rowNumber" ]; then
        grep -v "^$val:" "./Tables/$tbName" > "./Tables/$tbName.tmp"
        mv "./Tables/$tbName.tmp" "./Tables/$tbName"
        echo "Row with primary key $val has been deleted"
    else
        echo "#### Row not found."
    fi
else
    echo "#### Table not found or corrupted."
fi

