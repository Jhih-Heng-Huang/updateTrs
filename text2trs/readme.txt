This program is used to update the content of .trs file when you modified the content of .text file.
When you execute text2trs.pl, it will read each location of the text file in text.lst to replace every transcript of the .trs file to a new transcript from each line of the .text file.
Thus, it will create a new .trs file by updating the old .trs file and we have the following three files in the same place.
	<file name>.trs
	<file name>.text
	update_<file name>.trs


Steps:

1. Write down each text files with the full path in text.lst1 and the format of each path is as following:
	<full path>/<xxxx.text>
The following two lines are the example in text.lst:
	/home/albert/work/corpus/temp/_Tsai_Feng_An_30_131105-1030101-0119.text

2. Run text2trs.pl with the following command in the linux:
	perl text2trs.pl