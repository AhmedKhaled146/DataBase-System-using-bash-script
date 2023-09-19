#!/bin/bash

read -p "Enter Table Name: " tbName

if [ "$tbName" ] && [ -f "./Tables/$tbName" ] && [ -f "./Metadata/$tbName" ] 
then
    ## Get the data from the table and then convert it to an array
    colNames=($(awk -F: '{print $1}' ./Metadata/"$tbName"))
    colTypes=($(awk -F: '{print $2}' ./Metadata/"$tbName"))
    colPK=($(awk -F: '{print $3}' ./Metadata/"$tbName"))
            
    echo "Enter the values of["${colNames[*]}"] respectively"
    read  -a input	

    ## if input exists and the number of columns is the same as in the table
    if [[ "${input[@]}" ]] && [[ ${#input[@]} -eq "${#colNames[@]}" ]]
    then			

        ## check if the column types matches the data if not then will return to the main while loop
        for i in ${!input[@]}
        do	
            if [ ${colPK[$i]} = "p" ]
            then
                primaryKeyValue=${input[$i]}
            fi

            if [[ ${colTypes[$i]} = "i" ]] && ! [[ ${input[$i]} =~ ^[0-9]+$ ]]
            then
                echo "!Error: value ${input[$i]} is not a valid integer"
                exit
            fi
        done

        ## check for the primary key constrains[unique]
        if [ `awk -F : -v primaryKeyVal=$primaryKeyValue 'BEGIN{ found="false"; }
            { if( primaryKeyVal == $1) found="true" ;} END{ print found;}' ./Tables/$tbName` = "true"  ]
        then
            echo "!Error: Primary key must be unique"
            exit
        fi

        for i in ${!input[@]}
        do
            ## if not the last line then print element + delimiter
            if (( $i < ${#input[@]}-1 ))
            then
                echo -n "${input[$i]}:" >> "./Tables/$tbName"
            else
                ## last line print element + \n
                echo "${input[$i]}" >> "./Tables/$tbName"
            fi
        done	


    else
        echo "!Error: invalid input"
    fi
    

else
    echo "!Error: the table does not exist or is corrupted"
fi
