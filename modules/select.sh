#!/usr/bin/bash

read -p "Enter the name of the table: " tbName

if [ -f "./Tables/$tbName" ]; then
    # Get the primary key column number
    pkColNo=$(cut -d: -f4 "./Metadata/$tbName" | grep -n -w "p" | cut -d: -f1)

    read -p "Enter the value for the primary column or type \"ALL\" for all data listing: " pkValue

    # Check if the given value exists in the table
    rowNo=$(cut -d: -f$pkColNo "./Tables/$tbName" | grep -n -w "$pkValue" | cut -d: -f1)

    # If the user wants to see all rows, print metadata and all data
    if [ "${pkValue^^}" = "ALL" ]; then
        cut -d: -f1 "./Metadata/$tbName" | tr ':' ' ' | xargs printf "%-20s %-20s %-20s %-20s\n"
        cut -d: -f1,2,3,4 "./Tables/$tbName" | tr ':' ' ' | xargs printf "%-20s %-20s %-20s %-20s\n"
        exit
    fi

    # If the row exists, print specific columns and their values
    if [ "$rowNo" != "" ]; then
        #cut -d: -f1,2,3,4 "./Metadata/$tbName" | tr ':' ' ' | xargs printf "%-20s %-10s %-10s %-10s\n"
        cut -d: -f1,2,3,4 "./Tables/$tbName" | sed -n "${rowNo}p" | tr ':' ' ' | xargs printf "%-20s %-10s %-10s %-10s\n"
    else
        echo "#### Row not found."
    fi

else
    echo "#### no table named \"$tbName\" in the current database"
fi

