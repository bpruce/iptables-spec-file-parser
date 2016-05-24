#/bin/bash
declare result
now=$(date +"%m_%d_%Y")
cat ../edgeTable_$now.csv | while read -r line 
do
   if [[ $line == *"multi"* ]] ; then
      fields=($line)
      
      #protocol is always fixed @3
      prot=${fields[3]}
      #filename is always last entry
      fw_name=$(basename "${fields[*]: -1}")
      
      #test for any source and multi ports
      if [ "${fields[5]}" = "multiport" ] ; then
        srcip="any"
        ports=${fields[7]}
      else 
        srcip=${fields[5]}
        ports=${fields[9]}
      fi

      echo $prot $srcip $ports $fw_name >> ../test.csv
      # empty the $result array
      unset result 
   else
      xx=$( echo $line | cut -d' ' -f4,6,8,15 ) 
      echo $xx >> ../test.csv
   fi
done
exit
