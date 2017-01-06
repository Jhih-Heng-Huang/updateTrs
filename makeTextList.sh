outputFile=text.lst;
# clean the output file
# $@ should be a full path
echo "$0 $@";
echo -e "\c">$outputFile;

# write down all the full position of transcrips
# folderList=`ls -d $@`;
for folder in $@;do
        # echo $folder;
        textList=`ls $folder|grep .text`;
        # echo $trsList;
        for textFile in $textList;do
                echo "$folder$textFile" >> $outputFile;
        done
done

