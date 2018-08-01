#!/bin/bash

WORKING_DIR=/opt/mycom/test/shray_mf

cd $WORKING_DIR
echo "Removing the contents in the WORKING_DIR...\n"
if [ -d "$WORKING_DIR" ]; then rm -rf *; fi
echo "WORKING_DIR is cleaned up...\n"

#Getting the path of the file name to be processed
read -p 'Please, enter the absolute path of the file to be processed: ' FILE

#Getting the pattern to be searched in the file above
read -p 'Please, enter the pattern to be searched in the file provided: ' PATTERN

if [[ ! -f $FILE ]] ; then
    echo 'File provided is not there, aborting.'
    exit
fi

#Creating a temporary file
echo "Creating a temporary file.....\n"
grep -e "$PATTERN" $FILE | awk -F ";" '{print $1","$2","$3","$6}' > temp.txt
echo "Temporary file created\n"

echo "Processing the file...\n"
for i in "-2006" "-2007" "-2008" "-2009" "-2010" "-2011" "-2012" "-2013" "-2014" "-2015" "-2016" "-2017" "-2018"
do
    for j in "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"
    do 
        grep -e"$i" temp.txt | grep -e "$j" | head -1 >> processed.txt
    done
done

echo "File successfully processed ...\n"

#Copying the processed text file to a SQL file
echo "Copying the processed text file to a SQL file...\n"
cp processed.txt dataLoad.sql
echo "Copied the processed text file to a SQL file....\n"

#Creating the SQL file
echo "Creating the SQL file\n"
sed -i -e "s#^#INSERT INTO MASTER VALUES ('#g" dataLoad.sql
sed -i -e "s/,/','/g" dataLoad.sql
sed -i 's/\r\?$/end/' dataLoad.sql
sed -i -e "s/end/\'\)\;/g" dataLoad.sql
echo "Successfully created the SQL file\n"

