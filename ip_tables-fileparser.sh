#/bin/bash
now=$(date +"%m_%d_%Y")
touch ../tmpParse_$now.csv ../fw_edges_$now.csv
cat ../edgeTable_$now.csv | while read -r line
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
   
   echo "\"$prot $srcip $ports $fw_name\"" >> ../tmpParse_$now.csv
   unset prot srcip ports fw_name
done

#sort files 1) Node Name 2) Port 3) IP address
sort -k 4,4 -k 3,3n -k 2,2n ../tmpParse_$now.csv > ../fw_edges_$now.csv


exit