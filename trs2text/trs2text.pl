my $TEST = 0;
readTrsListToCreateText("trs.lst");

sub readTrsListToCreateText{
	use File::Basename;
	use utf8;

	local($input_file)=@_;
	open(trsList,"<$input_file") || die "Cannot open $input_file!\n";
	chomp(my @trsList=<trsList>);
	close(trsList);

	for(my $i = 0; $i < @trsList; ++$i){
		trsToText("@trsList[$i]");
	}
}

sub trsToText{
	use File::Basename;
	use utf8;

	local($trsFileName)=@_;
	open(trs,"<$trsFileName") || die "Cannot open $trsFileName!\n";
	chomp(my @trs=<trs>);
	close(trs);

	my @textContent = ();
	my $syncCount = sprintf("%04d",0);
	for(my $line=0; $line<@trs; ++$line){
		# extract the transcripts when encounter a new speaker
		if(@trs[$line]=~m/\<Turn speaker/){
			extractTransFromTurn(\$line,
								\@trs,
								\@textContent,
								$trsFileName,
								\$syncCount);
		}
	}


	# generate a .text according to the content of the .trs file
	$textFileName = $trsFileName;
	$textFileName =~s/.trs/.text/g;
	open(text,">$textFileName") || die "Cannot open $textFileName!\n";
	for(my $line=0; $line<@textContent; ++$line){
		print text "@textContent[$line]";	
	}
	close(text);
}


sub extractTransFromTurn{
	my $lineRef = $_[0];
	my $trsRef = $_[1];
	my $textContentRef = $_[2];
	my $trsFileName = $_[3];
	my $syncCountRef = $_[4];


	$trsFileName=~s/\.trs//g;
	@trsFileName=split(/\//,$trsFileName);

	my $turn = @$trsRef[$$lineRef];
	my @turn = split(/\ /,$turn);
	my $speaker = @turn[-3];

	$speaker =~s/speaker=|spk|\"|\>//g;
	$speaker = sprintf("%02d",$speaker);
	$speaker = "spk$speaker";

	# extract the transcripts
	my $endTurn = 1;
	for(;;++$$lineRef){
		$endTurn = parseLineFromTurn(@$trsRef[$$lineRef],
									@$trsRef[$$lineRef+1],
									@$trsRef[$$lineRef+2],
									$syncCountRef,
									@trsFileName[-1],
									$textContentRef,
									$speaker);

		if($endTurn){
			last;
		}
		else{}
	}

}


sub parseLineFromTurn{
	my $firstLine = $_[0];
	my $transcripts = $_[1];
	my $thirdLine = $_[2];
	my $syncCountRef = $_[3];
	my $trsFileName = $_[4];
	my $textContentRef = $_[5];
	my $speaker = $_[6];

	if( $firstLine=~m/\<\/Turn\>/ ){
		# the end of Turn
		return 1;
	}
	elsif( $firstLine=~m/\<Sync time/ && $thirdLine!~m/\<Event/){
		++$$syncCountRef;
		# the start the Sync time
		my @transcripts = split(/\//,$transcripts);
		$transcripts = @transcripts[-1];
		$transcripts =~s/\-|\,/\ /g;
		if( length($transcripts)>=2 && $transcripts!~m/\(|\)/ ){

			my @sync = split(/\ /,$firstLine);
			my $time = @sync[-1];
			$time=~s/time=|\"|\/|\>|\015//g;

			my $inputText = "$trsFileName\_$speaker\_$$syncCountRef\_$time $transcripts\n";
			push @$textContentRef, "$inputText";
		}
		else{}
	}
	else{}

	return 0;
}

# sub trsToText{
# 	use File::Basename;
# 	use utf8;

# 	local($input_file)=@_;
# 	open(trsList,"<$input_file");
# 	chomp(my @trsList=<trsList>);
# 	close(trsList);
	

# 	for(my $i=0; $i<@trsList; ++$i){
# 		my @temp = split(/\.trs/,@trsList[$i]);
# 		open(trs,"<@trsList[$i]");
# 		$txt_fileName = @temp[0].".text";
# 		open(txt_file,">$txt_fileName");
# 		chomp(my @trs=<trs>);
# 		close(trs);
		
# 		my $ut=0;
# 		for(my $j=0;$j<@trs;++$j)
# 		{
# 			if((@trs[$j] =~m/Sync time/) && (@trs[$j+2] !~m/Event/) && (@trs[$j+1] !~m/Sync time/) && (length(@trs[$j+1])>=2))
# 			{
# 				$text1=@trs[$j+1];
# 				@sls = split(/\//,$text1);
# 				$text = @sls[-1];
# 				$text=~s/,/ /g;
# 				$text=~s/\=/ /g;
# 				$text=~s/\./ /g;
# 				$text=~s/-/ /g; 
# 				$text=~ tr/\015//d;
# 				$text=~s/-$//;
# 				$text=~s/^\s+//;
# 				#print "$text1\n";
# 				@txt = split(/ /,$text);
# 				$ttt=0;
# 				for($k=0;$k<@txt;$k++)
# 				{
# 					$sword=@txt[$k];
# 					$sword=~ s/[a-z]//g;
# 					#print "$sword\n";
# 					$num=ord(substr(@txt[$k],0,1));
# 					$ch=substr(@txt[$k],0,1);
# 					if((length($sword)!=1) || ($num>127) || (@txt[$k]=~m/\[/) || (@txt[$k]=~m/\?/) || (@txt[$k]=~m/\]/) || (length(@txt[$k])<=1) || ($ch=~m/[0-9]]/))
# 					{$ttt=1}
					
# 				}
# 				if($ttt eq 0)
# 				{				
# 					@sp=split(/\"/,@trs[$j]);
# 					@ep=split(/\"/,@trs[$j+2]);
# 					$sHH=int(@sp[1]/3600);
# 					$sMM=int((@sp[1]-$sHH*3600)/60);
# 					$sSS=(@sp[1]-$sHH*3600-$sMM*60);
# 					$eHH=int((@ep[1]-@sp[1])/3600);
# 					$eMM=int(((@ep[1]-@sp[1])-$eHH*3600)/60);
# 					$eSS=((@ep[1]-@sp[1])-$eHH*3600-$eMM*60);
# 					$stn=int(@sp[1]);
# 					$etn=int(@ep[1]-@sp[1]);
# 					my $utt=sprintf("%04d",$ut);
# 					my $spp=sprintf("%02d",$sk);
# 					my $sH=sprintf("%02d",$sHH);
# 					my $eH=sprintf("%02d",$eHH);
# 					my $sT=sprintf("%02d",$sMM);
# 					my $eT=sprintf("%02d",$eMM);
# 					my $sS=sprintf("%.3f",$sSS);
# 					my $eS=sprintf("%.3f",$eSS);
# 					my $et=sprintf("%02d",$etn);
# 					my $st=sprintf("%04d",$stn);
# 					if($etn<=10)
# 					{
# 						$ut++;
# 						@temp = split(/\//,"@trsList[$i]");
# 						@temp[-1]=~s/\.trs|\n//g;
# 						$wavname=@temp[-1];
# 						$wavname=$wavname."_spk".$spp."_".$utt.".".$st."-".$et;
# 						print txt_file "$wavname $text\n";
# 						$allwav=$allwav+@ep[1]-@sp[1];
# 						$allutt++;
# 					}
# 				}
# 			}
# 			elsif(@trs[$j] =~m/ speaker=/)
# 			{
# 				@skk= split(/speaker/,@trs[$j]);
# 				@skp= split(/\"/,@skk[1]);
# 				$sk=@skp[1];
# 				$sk=~s/spk//;
# 				#print "$sk\n";
# 			}
# 			elsif(@trs[$j] =~m/Sync/)
# 			{
# 				$orgutt++;
# 			}
# 		}
		
		
		
# 		close(txt_file);
# 		print "$txt_fileName is generated\n";
# 	}

# }