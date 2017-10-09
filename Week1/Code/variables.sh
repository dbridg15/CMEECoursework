#!/bin.bash
# Author: David Bridgwood dmb2417@ic.ac.uk                                      
# Script: variables.sh                                                        
# Desc: An example script demonstrating variables 
# Arguments: none                                                               
# Date: Oct 2017  

MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVa
## Reading multiple values
echo 'Enter two numbers seperated by space(s)'
read a b 
echo 'you entered' $a 'and' $b '.Their sum is:' 
mysum=`expr $a + $b`
echo $mysum
