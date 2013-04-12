#!/usr/bin/perl -w
use POSIX;

$folder=shift;
$ecartVariable=shift;
$max=-1;
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

sub indexArray($@)
{
 my $s=shift;
 $_ eq $s && return @_ while $_=pop;
 -1;
}

sub indexArray2
{
	my ($value, @arraytotest) = @_;
	my $indexi = (scalar @arraytotest)-1;
	while($indexi >=0 ){
		if($arraytotest[$indexi] eq $value){
			return $indexi;
			last;
		}
	$indexi--;
	}
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
	open (CLUSTERFILE,">$folder/CLUSTERFILE-$ecart.txt") || die "couldn't open the file!";
	print CLUSTERFILE "DELTA:SYM:ENV:DETAILDIFFERENCE:ELEMENTS:NormalizeSYM:NormalizeENV\n";
	open (CLUSTERFILEALL,">$folder/CLUSTERFILE-COMPLETE-$ecart.txt") || die "couldn't open the file!";
	print CLUSTERFILEALL "DELTA:SYM:ENV:DETAILDIFFERENCE:ELEMENTS:NormalizeSYM:NormalizeENV\n";
	
		%hashBlock=();
		@arrayValues=();
		@arrayValues1=();
		open (SCORES,"$folder/input.txt") || die "ERROR: CEBA couldn't open the file $folder/input.txt";
		while ($line =<SCORES>){
			if ($line =~ /^Unicity/){}
			else{
				if ($line =~ /^(\s)*$/){}
				else{
					@scoreData=();
					chomp $line;
					@scoreData=split(" ",$line);
					$b1=$scoreData[0];
					$b2=$scoreData[1];
					$hash_pair_Score{$b1}{$b2}=($scoreData[2]);
					#print $b1."\n";
					push (@arrayValues1,$hash_pair_Score{$b1}{$b2});
					if($hash_pair_Score{$b1}{$b2}>$max){
					$max=$hash_pair_Score{$b1}{$b2};
					}
					$hashBlock{$b1}=1;
					$hashBlock{$b2}=1;
				}
			}
		}	
		close(SCORES);
		@arrayValues=sort{$a<=>$b}@arrayValues1; 

%hash_pair_ScoreIQ=();
@arrayValues=sort {$a<=>$b}@arrayValues1;
$intervalleLength = int($ecart * scalar (@arrayValues)/100);
$indexInterval=0;
#print ">>>>>".(scalar (@arrayValues))."\n";
while( $indexInterval <  (scalar @arrayValues)){
   if($indexInterval+$intervalleLength < scalar (@arrayValues)){
   $hash_pair_ScoreIQ{$arrayValues[$indexInterval]}=$arrayValues[$indexInterval+$intervalleLength ];
   }else{
    $hash_pair_ScoreIQ{$arrayValues[$indexInterval]}=$max;
   }
  # print $indexInterval." ".$hash_pair_ScoreIQ{$arrayValues[$indexInterval]}."\n";
   $indexInterval++;
}		
		#ETAPE2: CUTTING SCORES INTO PERCENTILE
		@classValue1=();
		@classValue2=();
		#print "\n-----------------------\n";
		for ($count = 0; $count < ceil(100/$ecart)-1; $count++){
			$cut=100-(($count+1)*$ecart);
			if($cut<0){
				$cut=0;			
			}
			$classValue1[$count]=percentile($cut,\@arrayValues);
			#print $classValue1[$count]." ";
		}
		#print "\n-----------------------\n";
		for ($count = 0; $count <ceil(100/$ecart)-1; $count++){
			$cut=100-(($count+1)*$ecart+($ecart/2));
			if($cut<0){
				$cut=0;			
			}
			$classValue2[$count]=percentile($cut,\@arrayValues);
		#	print $classValue2[$count]." ";
		}
		#print "\n-----------------------\n";
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


		#do{
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
		#}while($boolIterate eq 1);




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

		#do{
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
		#}while($boolIterate eq 1);

$valueTREATA=$classValue2[0];
for ($indexTREAT = 1; $indexTREAT < (scalar @classValue2); $indexTREAT++){
	#print $valueTREATA."\n";
	$valueTREATA=$classValue2[$indexTREAT];
}
#print $valueTREATA."\n";
#print "==============================\n\n";
#print "END PROCESS\n\n";			

			@keys=();
			@keys = keys %hashBlock;
			$NumberBlocks=scalar @keys;
			%hashBlock=();
			@keys=();
			@keys = sort keys %hash_pair_Score;		
			#print "$varNMU $NumberBlocks ";
			foreach $blockA(@keys){	
				foreach $blockB(@keys){	
					if($blockA eq $blockB){	
					
					#print "HERE? $blockA $blockB";
					}
					else{	
				
						
						#Getting range values of block A and B
						$value=&restrict_num_decimal_digits($hash_pair_Score{$blockA}{$blockB},5);
						@arraySORT=();
						@arraySORT=@classValue1;
						#print "A/B ::", $value,"\n";
						push (@arraySORT,$value);
						@arraySORTSorted =();
						@arraySORTSorted =  sort{$a<=>$b} @arraySORT;
						$rangeA1=indexArray($value,@arraySORTSorted);
						$minRangeGRID1=$rangeA1;
						$distRangeGRID1=$value-$arraySORTSorted[$rangeA1-1];
							
						@arraySORT=();
						@arraySORT=@classValue2;
						#print "scalar array ".scalar@arraySORT."\n";
						push (@arraySORT,$value);
						@arraySORTSorted =();
						@arraySORTSorted =  sort{$a<=>$b} @arraySORT;
						$rangeA2=indexArray($value,@arraySORTSorted);
						$minRangeGRID2=$rangeA2;
						$distRangeGRID2=$value-$arraySORTSorted[$rangeA2-1];						

						$value=&restrict_num_decimal_digits($hash_pair_Score{$blockB}{$blockA},5);
						#print "B/A ::", $value,"\n";					
						@arraySORT=();
						@arraySORT=@classValue1;
						push (@arraySORT,$value);
						@arraySORTSorted =();
						@arraySORTSorted =  sort{$a<=>$b} @arraySORT;
						$rangeB1=indexArray($value,@arraySORTSorted);
						if($rangeB1<$minRangeGRID1){
							$minRangeGRID1=$rangeB1;
							$distRangeGRID1=$value-$arraySORTSorted[$rangeB1-1];
						}
						
						
						@arraySORT=();					
						@arraySORT=@classValue2;
						push (@arraySORT,$value);
						@arraySORTSorted =();
						@arraySORTSorted =  sort{$a<=>$b} @arraySORT;
						$rangeB2=indexArray($value,@arraySORTSorted);
						if($rangeB2<$minRangeGRID2){
							$minRangeGRID2=$rangeB2;
					    	$distRangeGRID2=$value-$arraySORTSorted[$rangeB2-1];
						}
					
						$indexRange=0;						
						if (($rangeA1 eq $rangeB1 )){
							$indexRange= $rangeA1."0";	
							$yesValue=1;
						}
						else{ 
							if (($rangeA2 eq $rangeB2 )){
								$temp=$rangeA2-1;
								$indexRange= $temp."5";
								$yesValue=1;
							}
							else{
								if($distRangeGRID2<$distRangeGRID1){
								$indexRange=$minRangeGRID2."5";
								}
								else{
								$indexRange=$minRangeGRID1."0";
								}
								$h1=$hash_pair_Score{$blockA}{$blockB};
								$h2=$hash_pair_Score{$blockB}{$blockA};
								if($hash_pair_Score{$blockA}{$blockB}<$hash_pair_Score{$blockB}{$blockA}){
								#$yesValue=$hash_pair_ScoreIQ{$blockA}{$blockB};
								$yesValue=0;
								if($hash_pair_ScoreIQ{$h1}>=$h2){
								$yesValue=1;
								}
								if($yesValue eq 1){	
										if((($rangeB1-$rangeA1)>1) and (($rangeB2-$rangeA2)>1)){
											$yesValue =0;
										}
									}
								}else{
									
									#$yesValue=$hash_pair_ScoreIQ{$blockA}{$blockB};
									$yesValue=0;
									if($hash_pair_ScoreIQ{$h2}>=$h1){
									$yesValue=1;
									}
									if($yesValue eq 1){	
										
										if((($rangeA2-$rangeB2)>1) and ( ($rangeA1-$rangeB1)>1)){
											$yesValue =0;
										}
									
									}
								}
							}
						}
						
						
					
						if($yesValue eq 1){	
						#print ">>>>Symmetric scores!!\n";
						
							$differenceCount=0;
							$difference="";
							@keysHS =();						
							@keysHS = sort keys %hash_pair_Score;
							$indexA=0;
							foreach $block(@keysHS){
								if($block ne $blockA and $block ne $blockB){
								 if(exists $hash_pair_Score{$blockA}{$block} ){
										@arraySORT=();
										@arraySORT=@classValue1;
										push (@arraySORT,$hash_pair_Score{$blockA}{$block});
										@arraySORT =  sort{$a<=>$b}(@arraySORT);
										$rangeC1=indexArray($hash_pair_Score{$blockA}{$block},@arraySORT);

										@arraySORT=();
										@arraySORT=@classValue2;
										push (@arraySORT,$hash_pair_Score{$blockA}{$block});
										@arraySORT =  sort{$a<=>$b}(@arraySORT);
										$rangeC2=indexArray($hash_pair_Score{$blockA}{$block},@arraySORT);
									}else{
										print "ERROR  BA: $blockA B: $block\n";
									}
									if(exists $hash_pair_Score{$blockB}{$block} ){
										@arraySORT=();
										@arraySORT=@classValue1;
										push (@arraySORT,$hash_pair_Score{$blockB}{$block});
										@arraySORT =  sort{$a<=>$b}(@arraySORT);
										$rangeD1=indexArray($hash_pair_Score{$blockB}{$block},@arraySORT);

										@arraySORT=();
										@arraySORT=@classValue2;
										push (@arraySORT,$hash_pair_Score{$blockB}{$block});
										@arraySORT =  sort{$a<=>$b}(@arraySORT);
										$rangeD2=indexArray($hash_pair_Score{$blockB}{$block},@arraySORT);
									}
									else{
										print "ERROR BB: $blockB B: $block\n";
									}
									if($rangeC1 ne $rangeD1 and $rangeC2 ne $rangeD2 ){
										
										
										##########
$h1=$hash_pair_Score{$blockA}{$block};
$h2=$hash_pair_Score{$blockB}{$block};
										if($h1<$h2){
										#print "A: ".$blockA."/".$block." ".$hash_pair_Score{$blockA}{$block}." ----- ";
										#print "B: ".$blockB."/".$block." ".$hash_pair_Score{$blockB}{$block}."\n";
										#$yesValue=inQuantile($hash_pair_Score{$blockA}{$block},$hash_pair_Score{$blockB}{$block},$ecart, \@arraycopy);
$yesValue=0;
if($hash_pair_ScoreIQ{$h1}>=$h2){
$yesValue=1;
}
										if($yesValue eq 1){	
												if((($rangeD1-$rangeC1)>1) and (($rangeD2-$rangeC2)>1)){
												
													$yesValue =0;
												}
											}
										}else{
											
										#$yesValue=inQuantile($hash_pair_Score{$blockB}{$block},$hash_pair_Score{$blockA}{$block},$ecart, \@arraycopy);
$yesValue=0;
if($hash_pair_ScoreIQ{$h2}>=$h1){
$yesValue=1;
}										
											if($yesValue eq 1){	
												
												if((($rangeC1-$rangeD1)>1) and ( ($rangeC2-$rangeD2)>1)){
													$yesValue =0;
												}
											
											}
										}
										##########
										
										if($yesValue eq 1){	
										}else{
											$differenceCount++;
											$difference=$difference." ".$block;
										}
									}
								
							
								}
								$indexA++;
							}
							#Differences
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
							$indexBlockA=indexArray($blockA,@{$hashDifference{$indexRange}{$difference}});
							if ($indexBlockA eq -1){
								push @{ $hashDifference{$indexRange}{$difference} },$blockA;
								
							}
							$indexBlockB=indexArray($blockB,@{$hashDifference{$indexRange}{$difference}});
                            if ($indexBlockB eq -1){
#                             @arraySortedHD =sort @{$hashDifference{$indexRange}{$difference}};
#                             $i=0;
  #                           $total=0;
#                             while( $i<scalar @arraySortedHD){
#                      $b=$arraySortedHD[$i];    
#$h1=$hash_pair_Score{$b}{$blockB};
#$h2=$hash_pair_Score{$blockB}{$b};
#$yesValue=   0;
#if($h1<$h2){
#	if($hash_pair_ScoreIQ{$h1}>=$h2){
#$yesValue=   1;
#	}
#}else{
#if($hash_pair_ScoreIQ{$h2}>=$h1){
#$yesValue=   1;
#	}
#}
#								                                                          
#								$total=$total+$yesValue;
#                                $i++;
#                              }
#                       
 #                            if($total= (scalar @arraySortedHD)){
                                 push @{ $hashDifference{$indexRange}{$difference} },$blockB;
#                                }
                            }       
						
						
						}else{
							
						}
						
					}
				}#close blockB
				@keysD1=();
				@keysD1 = keys %hashDifference;
				foreach $indexR(@keysD1){
					@keysD=();
					@keysD = keys %{$hashDifference{$indexR}};
					foreach $blockDifference(@keysD){
						@arraySortedHD=();
						@arraySortedHD =sort @{$hashDifference{$indexR}{$blockDifference}};
						$i=0;
						$blockList="";
						while( $i<scalar @arraySortedHD){
							$blockList=$blockList." $arraySortedHD[$i]";
							$i++;
						}
						$hashResult{$indexR}{$blockList}=$blockDifference;	
						if($blockDifference eq -1){
						$originalClusterRelevance=$indexR;
#$sA= (scalar @classValue1);
#$sB= (scalar @classValue2);
#print $sA.":".$sB."\n";
						if((scalar @classValue2)>(scalar @classValue2)){
				$tempCeil=ceil((((scalar @classValue2) +1)*10)/10)*10;
				}else{
				$tempCeil=ceil((((scalar @classValue1) +1)*10)/10)*10;}
				
				$normalizedClusterRelevance = (($originalClusterRelevance*2)/($tempCeil-10))-1;
							#print $blockA.":".$blockList.":$normalizedClusterRelevance\n";
						}
						$blockList="";
					}
				}
				
				%hashDifference=();				
			}#close BlockA
		
		}
		%hash_pair_Score=();
		@keysRI =();
		@keysRI = reverse sort keys %hashResult;
		foreach  $indexCluster(@keysRI){
			@keysR =();
			@keysR = sort keys %{$hashResult{$indexCluster}};
			foreach $cluster(@keysR){
				if($hashResult{$indexCluster}{$cluster} eq "-1"){
					$ratio=100;
				}else{
					@DifferBlockArray=();
					@DifferBlockArray = split(" ",$hashResult{$indexCluster}{$cluster});
					$differBlocksSize=scalar @DifferBlockArray;
					$ratio=100-($differBlocksSize/($NumberBlocks))*100;
				}
			
				$originalClusterRelevance=$indexCluster;
			if((scalar @classValue2)>(scalar @classValue2)){
                               $tempCeil=ceil((((scalar @classValue2) +1)*10)/10)*10;
                               }else{
                               $tempCeil=ceil((((scalar @classValue1) +1)*10)/10)*10;}
				$normalizedClusterRelevance = (($originalClusterRelevance*2)/($tempCeil-10))-1;
				$originalRessemblance=$ratio;
				$normalizedRessemblance = (($originalRessemblance*2)/100)-1;
				if($normalizedClusterRelevance>=0 and $normalizedRessemblance>=0){
					print CLUSTERFILE "$ecart:$indexCluster:$ratio:".$hashResult{$indexCluster}{$cluster};
					$cluster =~ tr/\:/\\/;
					print CLUSTERFILE ":$cluster";
					print CLUSTERFILE ":$normalizedClusterRelevance".":$normalizedRessemblance\n";
				}
		
				print CLUSTERFILEALL "$ecart:$indexCluster:$ratio:".$hashResult{$indexCluster}{$cluster};
					$cluster =~ tr/\:/\\/;
					print CLUSTERFILEALL ":$cluster";
					print CLUSTERFILEALL ":$normalizedClusterRelevance".":$normalizedRessemblance\n";
							
			}
		}
		%hashResult=();			
		

	close (CLUSTERFILE);
	close (CLUSTERFILEALL);
	%hash_pair_Score=();
	%hashBlock=();
	%hash_pair_ScoreIQ=();
 	@arrayValues=();
    @arrayValues1=();
    @classValue1=();
    @classValue2=();
	$index=$index+1;
}


exit;
