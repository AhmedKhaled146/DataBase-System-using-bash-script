#!/usr/bin/bash

# Get the modules folder path from the DB.sh script
modules="$1"

# Check and create Tables and Metadata folders if they don't exist
if [ ! -d "Tables" ]; then
    mkdir "Tables"
    echo "Tables Directory Created"
fi

if [ ! -d "Metadata" ]; then
    mkdir "Metadata"
    echo "Metadata Directory Created"
fi

while true; do
    echo -e "\nSelect an option:"
    echo "  1- Create Table"
    echo "  2- List Tables"
    echo "  3- Drop Table"
    echo "  4- Insert Into Table"
    echo "  5- Select From Table"
    echo "  6- Delete From Table"
    echo "  7- Update Table"
    echo "  8- Disconnect Database"

    read -p "Option: " option

    case "$option" in
        "1")
            "$modules/create.sh"
            ;;

        "2")
            echo "there is your tables in your database: "
            ls "./Tables/"
            ;;

        "3")
            "$modules/drop.sh"
            ;;

        "4")
            "$modules/insert.sh"
            ;;

        "5")
            "$modules/select.sh"
            ;;

        "6")
            "$modules/delete.sh"
            ;;

        "7")
            "$modules/update.sh"
            ;;

        "8")
            exit
            ;;
        *)
            echo "Hey Invalid option. Please select a valid option again."
            ;;
    esac
done

