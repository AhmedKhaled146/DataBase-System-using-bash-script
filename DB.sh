#!/usr/bin/bash
#########################       Made By Ayman Farag & Ahmed Khalid       ###################################
# Modules folder location

modules="$PWD/modules"

# create DBS directory if not exist for put all databases in it
if [ ! -d "./DBS/" ]; then
    mkdir "DBS"
    echo "DBS created"
fi

while true; do
    echo -e "\nSelect an option:"
    echo "  1- Create Database"
    echo "  2- List Databases"
    echo "  3- Connect to Database"
    echo "  4- Drop Database"
    echo "  5- Exit Application"
    
    read -p "Option: " option

    case "$option" in 
        "1")
            read -p "Enter the name of the Database [must start with an alphabet]: " dbName
            
            # Check if dbname start with characters Like this [Test1, test2,asd] Not like this [55, 23test]
            if [[ $dbName =~ ^[A-Za-z]+[0-9]* ]]; then
            
            # Check if the dbname exists or not
                if [ -d "./DBS/$dbName" ]; then
                    echo "Database already exists"
                else
                    mkdir "./DBS/$dbName"
                    echo "Database created."
                fi
            else
                echo "#### Database name must start with character."
            fi
            ;;

        "2")
        	# List all DBs
            echo "##### That is Your Databases: "
            ls "./DBS/"
            ;;

        "3")
            read -p "Enter the name of the Database to connect to: " dbName
            if [ -d "./DBS/$dbName" ]; then
                cd "./DBS/$dbName" || exit
                echo "Database $dbName Connected"
                "$modules/Tables.sh" "$modules"
                cd ../..
            else
                echo "Database does not exist"
            fi
            ;;

        "4")
            read -p "Enter the name of the Database to drop: " dbName
            if [ -d "./DBS/$dbName" ]; then
                read -p "Are you sure you want to drop $dbName Database with all tables? [y/n]: " check
                if [[ "${check}" =~ ^[Yy]$ ]]; then
                    rm -r "./DBS/$dbName"
                    echo "Database $dbName dropped."
                fi
            else
                echo "#### Database does not exist!"
            fi
            ;;

        "5")
            exit
            ;;
        *)
            echo "##### Invalid option. PLZ select vaild option"
            ;;
    esac
done

