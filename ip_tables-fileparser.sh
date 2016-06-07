#!/bin/bash
#title           :
#description     :
#author		 :
#date            :
#version         :0.1   
#usage		 :
#notes           :
#bash_version    :
#==============================================================================

#
# Tunable settings
#
DATA_DIR=.

now=$(date +"%m_%d_%Y")
rm *.iptmp # remove any stale datafiles

#should read in the csv files
IPFILES=$DATA_DIR/*.csv
for CSV_FILE in $IPFILES
do
  OUT_FILE=$CSV_FILE.iptmp
  echo "Now processing ${CSV_FILE}"
  touch $OUT_FILE
  cat $CSV_FILE | while read -r line
  do
    fields=($line)
    #fixed
    prot=${fields[3]}
    srcip=${fields[5]}
    ports=${fields[7]}
    fw_name=$(basename "${fields[*]: -1}")
   
    #ftp server testing should happen first, then multi will reset if FTP has IP address src
    if [[ $line == *"ftp"* && $line != *"-s "* ]] ; then
      srcip="any"
        ports=${fields[5]}  
    fi
   
    #multiport line testing - can have no source, or source, so needs to test for this
    if [[ $line == *"multi"* ]] ; then
      #test for any source and multi ports
      if [ "${fields[5]}" = "multiport" ] ; then
        srcip="any"
        ports=${fields[7]}
      else 
        srcip=${fields[5]}
        ports=${fields[9]}
      fi
    fi
    echo "$prot $srcip $ports $fw_name" >> $OUT_FILE
  done
  echo "Found `wc -l $OUT_FILE` lines in $CSV_FILE"
  mv $OUT_FILE $CSV_FILE
done

#
# Now do the sorting on the data files
#
#sort files 1) Node Name 2) Port 3) IP address
#sort -k 4,4 -k 3,3n -k 2,2n ../tmpEdgeParse_$now.csv > 
#final output, parsed file here
#-------------------------------------
#OUT_FILES=$DATA_DIR/*.iptmp
#for TMP_FILE in $OUT_FILES
#do
#  OUTPUT=$TMP_FILE.frank
#  if [ ! -f $OUTPUT ] ; then
#    touch $OUTPUT
#  fi
#  sort -k4,4 -k3,3 -k2,2 $TMP_FILE >> $OUTPUT
#done
