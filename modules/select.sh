#!/bin/bash

read -p "Enter the name of the table: " tbName
if [ -f "./Tables/$tbName" ]
then
	## Get the primary key column number
	pkColNo=`awk -F : '{ if( $3 == "p" ) print NR; }' "./Metadata/$tbName"`
	
	read -p "Enter the value for the primary column or type \"ALL\" for all data listing: " pkValue
	
	## Check if the given value exists in table
	rowNo=`awk -v pkCol=$pkColNo -v pkVal=$pkValue -F : '
		BEGIN{rn=-1}
		{ if( $pkCol == pkVal ) rn = NR }
		END{ print rn }' "./Tables/$tbName"
		`
		
	## If the row = * then return all rows in a table in a nice format
	if [ ${pkValue^^} = "ALL" ]
	then
		awk -F : '{printf "%s(%s,%s) %-7s" ,$1,$2,$3, "" }END{printf "\n"}' "./Metadata/$tbName"
		awk -F : -v rowNo=$rowNo ' 
		{ for(i = 1 ; i <= NF ; i++){
			printf "  %s %-10s", $i , "";
			}
		printf "\n"
	 	} END{ printf "\n" }' "./Tables/$tbName"
	 	exit
	fi
	
	
	## If the row exists print its data in a nice format otherwise return an error
	if [ $rowNo != "-1" ]
	then

		awk -F : '{printf "%s(%s,%s) %-7s" ,$1,$2,$3, "" }END{printf "\n"}' "./Metadata/$tbName"
		awk -F : -v rowNo=$rowNo ' 
		{ 
		if( NR == rowNo ){
			for(i = 1 ; i <= NF ; i++){
				printf "  %s %-10s", $i , "";
				}
			printf "\n"
		}
	 	} END{ printf "\n" }' "./Tables/$tbName"
	else
		echo "!Error: Row not found." 
	fi
	
else
	echo "!Error: no table named \"$tbName\" in the current database"
fi
