 #!/bin/bash                                                                     
 # Author: David Bridgwood dmb2417@ic.ac.uk                                      
 # Script: tabtocsv.shs
 # Desc: Substitute the tabs in a file with commas
         Saves the output into a csv file
 # Arguments: 1-> tab deliminated file                                        
 # Date: Oct 2017

echo "Creating a comma deliminated version of $1 ..."

cat $1 | tr -s "\t" "," >> $1.csv

echo "Done (woo!)"

exit

