The program in this folder is used to generate a ".text" file from its source ".trs" file.
When you execute trs2text.pl, it will read each line in trs.lst to translate the .trs files into the .text files.
The format of each line in .text file is
	<trs file name>_<speaker number>_<speaking counter>_<time> <transcript>


Steps:

1. Write down each trs files with the full path in trs.lst and the format of each path is as following:
	<full path>/<xxxx.trs>
The following one line is the example in trs.lst:
	/home/albert/work/corpus/temp/_Tsai_Feng_An_30_131105-1030101-0119.trs

2. Execute trs2text.pl with the following command in the linux:
	perl trs2text.pl
