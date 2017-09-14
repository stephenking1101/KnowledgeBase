#!/bin/bash
##########################################################
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

echo "**************************************************Import Note**************************************************"
echo ""
echo "Plase read the following guide when using the G3 commander tool:"
echo "1> If you are getting monster characters, change Putty setting as below:"
echo "   1.a> Right click Putty menu bar, select 'Change Settings'"
echo "   1.b> Select 'Window' -> 'Transation'"
echo "   1.c> Change character set to 'UTF-8' in dropdown list"
echo "   1.d> Quit the command and re-run"
echo "2> Use arrow key to navigate options"
echo "3> Use space key to select option"
echo "4> Use enter key for option confirmation"
echo "5> Use Tab key to jump into <ok> / <cancel> button"
echo ""
echo "***************************************************************************************************************"

echo -ne "Please type 'yes' to acknowledge you get the above guide to continue:"
read input

if [ ${input} == "yes" ]; then
	./g3MainCommander.sh
else
	echo "You didn't confirm, exit"
fi
