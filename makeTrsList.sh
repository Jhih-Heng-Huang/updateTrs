outputFile=trs.lst;
# clean the output file
# $@ should be a full path
echo "$0 $@";
echo -e "\c">$outputFile;

# write down all the full position of transcrips
# folderList=`ls -d $@`;
for folder in $@;do
	# echo $folder;
	trsList=`ls $folder|grep .trs`;
	# echo $trsList;
	for trsFile in $trsList;do
		echo "$folder$trsFile" >> $outputFile;
	done
done
