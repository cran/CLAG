#!/usr/bin/perl -w
use POSIX;
$folder=shift;
$ecartVariable=shift;
$max=1;
#print $max."\n\n\n";
# restrict the number of digits after the decimal point
sub restrict_num_decimal_digits
{
  my $num=shift;#the number to work on
  my $digs_to_cut=shift;# the number of digits after 
		  	    # the decimal point to cut 
		#(eg: $digs_to_cut=3 will leave 
		# two digits after the decimal point)
  if ($num=~/\d+\.(\d){$digs_to_cut,}/)
  {
    # there are $digs_to_cut or 
    # more digits after the decimal point
    $num=sprintf("%.".($digs_to_cut-1)."f", $num);
  }
  return $num;
}

sub percentile {
my ($p,$aref) = @_;
my $percentile = int($p * $#{$aref}/100);
#print ">>>$p >>>".$percentile."\n";
#print "Percentile ".(scalar @$aref)." \n";
return (sort{$a<=>$b} @$aref)[$percentile];
}

@ecartVariableArray=split("/",$ecartVariable);
$index=0;
while($index<scalar @ecartVariableArray){
	$ecart=$ecartVariableArray[$index];
#	print "\n\nBEGIN PROCESS ECART:$ecart...\n";
	open (CLUSTERFILE,">$folder/CLUSTERFILE-$ecart.txt") || die "couldn't write into the file $folder/CLUSTERFILE-$ecart.txt!";
	open (CLUSTERFILEALL,">$folder/CLUSTERFILE-COMPLETE-$ecart.txt") || die "couldn't write into the file $folder/CLUSTERFILE-COMPLETE-$ecart.txt!";
	print CLUSTERFILE "DELTA:ENV:DETAILDIFFERENCE:ELEMENTS :Normalize ENV\n";
	print CLUSTERFILEALL "DELTA:ENV:DETAILDIFFERENCE:ELEMENTS :Normalize ENV\n";
		%hashResult=();		
		%hashDifference=();		
		%hash_pair_Score=();
		%hashBlock=();
		@arrayValues=();
		open (SCORES,"$folder/input.txt") || die "ERROR: CEBA couldn't open the file $folder/input.txt";
		while ($line =<SCORES>){
			if ($line =~ /^Unicity/){}
			else{
				if ($line =~ /^(\s)*$/){}
				else{
					@scoreData=();
					chomp $line;
					@scoreData=split(" ",$line);
					#print $scoreData[0]." ".$scoreData[1]." ".$scoreData[2]."\n";
					$hash_pair_Score{$scoreData[0]}{$scoreData[1]}=$scoreData[2];
					push (@arrayValues,$scoreData[2]);
					
				}
			}
		}	
		close(SCORES);
		@arraycopy=sort{$a<=>$b}@arrayValues;
#calculer Quantile()
$indexValueQ=0;
while($indexValueQ<scalar @arraycopy){

$valueQ=$arraycopy[$indexValueQ];
$indexi = $indexValueQ;
while(($indexi < scalar @arraycopy) and ($arraycopy[$indexi] eq $valueQ)){
		$indexi++;
}
$indexValueQ=$indexi;
$indexV=$indexi-1;
$percentile = int($ecart * (scalar @arraycopy)/100);
if(($indexV+$percentile) >= (scalar @arraycopy))
{
	$Value=$arraycopy[(scalar @arraycopy)-1];
	
}else{
	$Value=$arraycopy[$indexV+$percentile];
}
$hashQuantile{$valueQ}=$Value;
}

################
		@classValue1=();
		@classValue2=();
		for ($count = 0; $count < ceil(100/$ecart)-1; $count++){
			$cut=100-(($count+1)*$ecart);
			if($cut<0){
				$cut=0;			
			}
			$classValue1[$count]=percentile($cut,\@arrayValues);
		
		}
		for ($count = 0; $count <ceil(100/$ecart)-1; $count++){
			$cut=100-(($count+1)*$ecart+($ecart/2));
			if($cut<0){
				$cut=0;			
			}
			$classValue2[$count]=percentile($cut,\@arrayValues);
		
		}
		$size1=scalar @classValue1;
		$size2=scalar @classValue2;
		if(($size1 eq 0) or ($size2 eq 0)){	}
		else{
@data=();
		@classValue1 = sort{$a<=>$b}(@classValue1);
		$SUMMLENGTH=0;
		$valueTREATA=0;
#print "\n\nBEGIN PROCESS...\n";
		for ($indexTREAT = 0; $indexTREAT < (scalar @classValue1); $indexTREAT++){
			#print $valueTREATA."\n";
			$valueTREATB=$classValue1[$indexTREAT];
			push (@data,$valueTREATB-$valueTREATA);
			$valueTREATA=$classValue1[$indexTREAT];
		
		}
$valueTREATB=$max;
#print $valueTREATB."\n";
push (@data,$valueTREATB-$valueTREATA);
		
#print "_______________________\n\n";
@data = sort { $a <=> $b } @data;
if (not @data) {
    print "No values were given\n";
    exit;
}
$total = 0;
foreach my $v (@data) {
    $total += $v;
}
$average = $total / @data;
$median = @data % 2        ? $data[(@data-1)/2]  
           :                  ($data[@data/2-1]+$data[@data/2])/2
           ;
$sqtotal = 0;
foreach my $v (@data) {
    $sqtotal += ($average-$v) ** 2;
}
$std = ($sqtotal / @data) ** 0.5;
#print "Min: $data[0]   Max: $data[-1]   Total: $total   count: "      . @data . "  Average: $average\n";
#print "Median: $median   $sqtotal Standard deviation: $std\n";
		do{
			$boolIterate=0;
			$valueTREATA=0;
			for ($indexTREAT = 0; $indexTREAT < (scalar @classValue1); $indexTREAT++){			
				$valueTREATB=$classValue1[$indexTREAT];
				$IntervalLENGTH=$valueTREATB-$valueTREATA;
				if($IntervalLENGTH >$average+$std){
					#add values in @classValue
				
					push (@classValue1,($valueTREATB-($valueTREATB-$valueTREATA)/2));
					@classValue1 = sort{$a<=>$b}(@classValue1);
					$boolIterate=1;
				}
				$valueTREATA=$classValue1[$indexTREAT];
		
			}
			$valueTREATB=$max;
			$IntervalLENGTH=$valueTREATB-$valueTREATA;
			if($IntervalLENGTH >$average+$std){
				push (@classValue1,($valueTREATB-($valueTREATB-$valueTREATA)/2));
				@classValue1 = sort{$a<=>$b}(@classValue1);
				$boolIterate=1;
			}
		}while($boolIterate eq 1);

#$valueTREATA=$classValue1[0];
for ($indexTREAT = 1; $indexTREAT < (scalar @classValue1); $indexTREAT++){
	#print $valueTREATA."\n";
	$valueTREATA=$classValue1[$indexTREAT];
}
#print $valueTREATA."\n";
#print "==============================\n\n";
		@data=();
		$SUMMLENGTH=0;
		@classValue2 = sort{$a<=>$b}(@classValue2);
		$valueTREATA=0;
		for ($indexTREAT = 0; $indexTREAT < (scalar @classValue2); $indexTREAT++){
			#print $valueTREATA."\n";
			$valueTREATB=$classValue2[$indexTREAT];
			push (@data,$valueTREATB-$valueTREATA);
			$valueTREATA=$classValue2[$indexTREAT];
		
		}
$valueTREATB=$max;
#print $valueTREATA."\n";
push (@data,$valueTREATB-$valueTREATA);
#print "_______________________\n\n";
@data = sort { $a <=> $b } @data;
if (not @data) {
    print "No values were given\n";
    exit;
}
$total = 0;
foreach my $v (@data) {
    $total += $v;
}
$average = $total / @data;
$median = @data % 2        ? $data[(@data-1)/2]  
           :                  ($data[@data/2-1]+$data[@data/2])/2
           ;
$sqtotal = 0;
foreach my $v (@data) {
    $sqtotal += ($average-$v) ** 2;
}
$std = ($sqtotal / @data) ** 0.5;
#print "Min: $data[0]   Max: $data[-1]   Total: $total   count: "      . @data . "  Average: $average\n";
#print "Median: $median   $sqtotal Standard deviation: $std\n";
		do{
			$boolIterate=0;
			$valueTREATA=0;
			for ($indexTREAT = 0; $indexTREAT < (scalar @classValue2); $indexTREAT++){
			
				$valueTREATB=$classValue2[$indexTREAT];
				$IntervalLENGTH=$valueTREATB-$valueTREATA;
				if($IntervalLENGTH >$average+$std){
					
					push (@classValue2,$valueTREATB-($valueTREATB-$valueTREATA)/2);
					@classValue2 = sort{$a<=>$b}(@classValue2);
					$boolIterate=1;
				}
				$valueTREATA=$classValue2[$indexTREAT];
		
			}
			$valueTREATB=$max;
			$IntervalLENGTH=$valueTREATB-$valueTREATA;
			if($IntervalLENGTH >$average+$std){
				push (@classValue2,($valueTREATB-($valueTREATB-$valueTREATA)/2));
				@classValue2 = sort{$a<=>$b}(@classValue2);
				$boolIterate=1;
			}
		}while($boolIterate eq 1);
$valueTREATA=$classValue2[0];
for ($indexTREAT = 1; $indexTREAT < (scalar @classValue2); $indexTREAT++){
	#print $valueTREATA."\n";
	$valueTREATA=$classValue2[$indexTREAT];
}
#print $valueTREATA."\n";
#print "==============================\n\n";
#print "END PROCESS\n\n";

#print "\n\nLOOP1\n\n";	
			@keys=();
			@keys = keys %hashBlock;
			
			%hashBlock=();
			@keysA=();
			#@keysA = sort keys %hash_pair_Score;
			@keysA =  keys %hash_pair_Score;
			$indexblockA=0;

			$indexSize=0;
while ($indexblockA <(scalar @keysA)){
			$indexSize++;
			
			$blockAA=$keysA[$indexblockA];	
			$indexblockA++;
			@keysB = keys %{$hash_pair_Score{$blockAA}};
			foreach $blockBB(@keysB){

				@arraySORT=();
				@arraySORT=@classValue1;
				$indexSearch=0	;									
				while(($indexSearch<scalar@arraySORT) and ($hash_pair_Score{$blockAA}{$blockBB}>$arraySORT[$indexSearch])){
				$indexSearch++;
				}
				$hashrange1{$blockAA}{$blockBB}=$indexSearch;
									
				@arraySORT=();
				@arraySORT=@classValue2;
				$indexSearch=0	;									
				while(($indexSearch<scalar@arraySORT) and ($hash_pair_Score{$blockAA}{$blockBB}>$arraySORT[$indexSearch])){
				$indexSearch++;
				}
				$hashrange2{$blockAA}{$blockBB}=$indexSearch;

			}


}	

#print "\n\nLOOP2\n\n";

			@keys=();
			@keys = keys %hashBlock;
			
			%hashBlock=();
			@keysA=();
			#@keysA = sort keys %hash_pair_Score;
			@keysA =  keys %hash_pair_Score;
			$indexblockA=0;

			$indexSize=0;
			#$totalprint=0;
			while ($indexblockA <(scalar @keysA)){
			$blockA=$keysA[$indexblockA];
$indexSize++;	

	

				$indexblockB=0;	
				$indexblockA++;
				while ($indexblockB <(scalar @keysA)){
					$blockB=$keysA[$indexblockB];	
					$indexblockB++;

					if($blockA ne $blockB){
					$differenceCount=0;
					$difference="";
					$indexA=0;
					@keysB=();
					@keysB = keys %{$hash_pair_Score{$blockA}};
					$NumberBlocks= scalar @keysB;
					#print "->>".$indexblockB." over ".(scalar @keysA)."\n";
					foreach $block(@keysB){
						$rangeC1=$hashrange1{$blockA}{$block};
						$rangeC2=$hashrange2{$blockA}{$block};
						$rangeD1=$hashrange1{$blockB}{$block};
						$rangeD2=$hashrange2{$blockB}{$block};
						
						if($rangeC1 ne $rangeD1 and $rangeC2 ne $rangeD2 ){
						if($hash_pair_Score{$blockA}{$block}<$hash_pair_Score{$blockB}{$block}){
						
								if((($rangeD1-$rangeC1)>1) and ( ($rangeD2-$rangeC2)>1)){
									$yesValue =0;
								}else{
	#$yesValue=$hashyesValue{$blockA}{$block}{$blockB}{$block};
$ValueFunction=$hashQuantile{$hash_pair_Score{$blockA}{$block}};
if($ValueFunction >=$hash_pair_Score{$blockB}{$block}){
$yesValue=1;
}
else{
$yesValue=0;
}

								}
							
						}else{
							
							
						
								if((($rangeC2-$rangeD2)>1) and ( ($rangeC1-$rangeD1)>1)){
									$yesValue =0;
								}else{
#$yesValue=$hashyesValue{$blockB}{$block}{$blockA}{$block};
$ValueFunction=$hashQuantile{$hash_pair_Score{$blockB}{$block}};
if($ValueFunction >=$hash_pair_Score{$blockA}{$block}){
$yesValue=1;
}
else{
$yesValue=0;
}
}
							
						
						}
						if($yesValue eq 1){	
							}else{
							$differenceCount++;
							$difference=$difference." ".$block;
						}
					}
					$indexA++;
					}

					@differenceSArray=();
					@differenceSArray=	split(" ",$difference);
					@differenceSortedArray=();
					@differenceSortedArray =sort @differenceSArray;
					$difference="";	
					$i=0;								
					while( $i<scalar @differenceSortedArray){
						$difference=$difference." ".$differenceSortedArray[$i];
						$i++;
					}
			
					if($difference eq ""){
						$difference="-1";
					}
					$indexBlockA=-1;
					$indexBlockB=-1;
					foreach $e(@{$hashDifference{$difference}}){
						
						if($blockA eq $e){
							$indexBlockA=1;
						}
						if($blockB eq $e){
							$indexBlockB=1;
						}
					}
					
					if ($indexBlockA eq -1){
						push @{ $hashDifference{$difference}},$blockA;	
					}
					
					
					if ($indexBlockB eq -1){
						push @{ $hashDifference{$difference}},$blockB;
					}	
						
					}	
					
				}#close blockB
			
				@keysD1=();
				@keysD1 = keys %hashDifference;
				
				foreach $blockDifference(@keysD1){
					@arraySortedHD=();
					@arraySortedHD =sort @{$hashDifference{$blockDifference}};
					$i=0;
					$blockList="";
					while( $i<scalar @arraySortedHD){
						$blockList=$blockList." $arraySortedHD[$i]";
						$i++;
					}
					$hashResult{$blockList}=$blockDifference;
					#if($blockDifference eq "-1"){
					#@keyblockprint=split (" ",$blockList);
					#$countA=0;
					#$countB=0;
					#$countC=0;
					#foreach $blockPrint (@keyblockprint){
					#if($blockPrint<=50){$countA++; }
					#if($blockPrint>50 and $blockPrint<=100 ){$countB++;}
					#if($blockPrint>100 and $blockPrint<=150 ){$countC++;}
					#}
					#if($blockA<=50){
					#	if (($countB eq 0) and ($countC eq 0)){}
					#	else{print $blockA.": ".$blockList.":$blockDifference".":".($countB+$countC)."\n";
					#	$totalprint=$totalprint+$countB+$countC;}
					#}
					#if($blockA>50 and $blockA<=100 ){
					#if (($countA eq 0) and ($countC eq 0)){}
					#	else{print $blockA.": ".$blockList.":$blockDifference".":".($countA+$countC)."\n";
					#	$totalprint=$totalprint+$countA+$countC;}
					#}
					#if($blockA>100 and $blockA<=150 ){
					#if (($countA eq 0) and ($countB eq 0)){}
					#	else{print $blockA.": ".$blockList.":$blockDifference".":".($countA+$countB)."\n";
					#	$totalprint=$totalprint+$countA+$countB;}
					#}
					#}
					$blockList="";
					
				}
				
				%hashDifference=();				
			}#close BlockA
#print ">>>>".($totalprint/2)." ";
		}
		
		%hash_pair_Score=();
		@keysRI =();
		@keysRI = reverse sort keys %hashResult;
		foreach $cluster(@keysRI){
				if($hashResult{$cluster} eq "-1"){
					$ratio=100;
				}else{
					@DifferBlockArray=();
					@DifferBlockArray = split(" ",$hashResult{$cluster});
					$differBlocksSize=scalar @DifferBlockArray;
					$ratio=100-($differBlocksSize/$NumberBlocks)*100;
				}
			
				$originalRessemblance=$ratio;
				$normalizedRessemblance = (($originalRessemblance*2)/100)-1;
				if($normalizedRessemblance>=0){
					print CLUSTERFILE "$ecart:$ratio:".$hashResult{$cluster}.":$cluster".":"."$normalizedRessemblance\n";
				}
				print CLUSTERFILEALL "$ecart:$ratio:".$hashResult{$cluster}.":$cluster".":"."$normalizedRessemblance\n";
		}
%hashrange1=();
%hashrange2=();
		%hashResult=();			
		
		close (CLUSTERFILE);
		close (CLUSTERFILEALL);
		$index=$index+1;
}
exit 0;
