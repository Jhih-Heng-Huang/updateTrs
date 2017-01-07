readListToUpdateTrs();

sub readListToUpdateTrs{
	use File::Basename;
	use utf8;

	my $inputList = "text.lst";
	open(list,$inputList) || die "Cannot open $inputList!\n";
	chomp(my @list = <list>);
	close(list);

	for(my $i=0; $i<@list; ++$i){
		# print "@list[$i]\n";
		textToTrs("@list[$i]");
	}


}


sub textToTrs{
	use File::Basename;
	use utf8;

	local($input) = @_;
	my @input = split(/\//,$input);
	my $dir = $input;
	my $textFile = @input[-1];
	$dir=~s/@input[-1]//g;
	$dir=~s/\n//g;
	$textFile=~s/\n//g;
	# print "$input\n";
	# print "$dir\n";
	# print "$textFile\n";
	open(text,"<$input") || die "Cannot open $input!\n";
	chomp(my @text=<text>);
	close(text);
	

	# put each line of the .text file back to the .trs file
	my $trsFileName = "";
	my @tempTrs;
	my $existTrs = 0;
	for(my $i=0;$i<@text;++$i){
		my @tempText = split(/\_spk/i,@text[$i]);

		# next trs file
		if(!($trsFileName=~m/@tempText[0]/)){

			# check if the trs file exists or not
			$trsFileName=@tempText[0].".trs";
			if($trsFileName=~m/@tempText[0]/){
				open(trs,"<$dir/$trsFileName") || die "Cannot open $dir/$trsFileName!\n";;
				chomp(@tempTrs=<trs>);
				close(trs);

				$existTrs = 1;
			}
			else{
				$existTrs = 0;
			}
		}
		else{}

		
		if($existTrs == 1){

			# update tempTrs
			@tempText = split(/\_spk/,@text[$i]);
			@tempText = split(/\_/,@tempText[-1]);
			# @tempText = split(/\.|\s|\-/,@text[$i]);
			my $time = @tempText[2]+0.0;
			for(my $lineCount=0; $lineCount<@tempTrs; ++$lineCount){
				if(@tempTrs[$lineCount]=~m/Sync time\=\"$time/){
					# print "$i\n";
					# print "@tempTrs[$lineCount]\n";
					# print "@tempTrs[$lineCount+1]\n";
					my @temp = split(/\//,@tempTrs[$lineCount+1]);
					@tempText = split(/\s/,@text[$i]);
					@temp[1] = "";
					for(my $count=1; $count<@tempText; ++$count){
						@temp[1] = @temp[1].@tempText[$count]." ";
					}
					@tempTrs[$lineCount+1] = @temp[0]."\/\/".@temp[1];
					last;
				}
			}

			# if the next line in "text" is a new trs file,
			# then output the updated trs file
			@tempText = split(/\_spk/i,@text[$i+1]);
			if(!($trsFileName=~m/@tempText[0]/) || $i+1==@text ){
				# output the updated trs file into the "updated" folder
				open(newTrs,">$dir/update_$trsFileName") || die "Cannot open updated_$trsFileName!\n";
				for(my $lineCount=0; $lineCount<@tempTrs; ++$lineCount){
					print newTrs "@tempTrs[$lineCount]\n";
				}
				close(newTrs);
				print "Updated $trsFileName\n";
			}

		}
		else{}

	}
	
}