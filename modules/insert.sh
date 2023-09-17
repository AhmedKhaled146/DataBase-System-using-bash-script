#!/usr/bin/bash

read -p "Enter Table Name: " tbName

if [ "$tbName" ] && [ -f "./Tables/$tbName" ] && [ -f "./Metadata/$tbName" ]; then
    # Get the data from the table and then convert it to an array
    colNames=($(cut -d: -f1 "./Metadata/$tbName"))
    colTypes=($(cut -d: -f2 "./Metadata/$tbName"))
    colPK=($(cut -d: -f3 "./Metadata/$tbName"))

    echo "Enter the values of ["${colNames[*]}"] respectively"
    read -a input

    # if input exists and the number of columns is the same as in the table
    if [[ "${input[@]}" ]] && [[ ${#input[@]} -eq "${#colNames[@]}" ]]; then
        primaryKeyValue=""

        # check if the column types match the data; if not, return to the main while loop
        for i in ${!input[@]}; do
            if [ "${colPK[$i]}" = "p" ]; then
                primaryKeyValue="${input[$i]}"
            fi

            if [[ "${colTypes[$i]}" = "i" ]] && ! [[ "${input[$i]}" =~ ^[0-9]+$ ]]; then
                echo "#### value ${input[$i]} is not a valid integer"
                exit
            fi
        done

        # check for the primary key constraint (unique)
        if grep -q "^${primaryKeyValue}:" "./Tables/$tbName"; then
            echo "#### Primary key must be unique"
            exit
        fi

        for i in ${!input[@]}; do
            # if not the last line, then print element + delimiter
            if (( $i < ${#input[@]} - 1 )); then
                echo -n "${input[$i]}:" >> "./Tables/$tbName"
            else
                # last line, print element + newline
                echo "${input[$i]}" >> "./Tables/$tbName"
            fi
        done
    else
        echo "#### invalid input"
    fi
else
    echo "#### the table does not exist or is corrupted"
fi

