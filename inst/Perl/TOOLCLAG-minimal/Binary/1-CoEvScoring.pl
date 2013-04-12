#!/usr/bin/perl -w
use POSIX;

$folder=shift;


open (CLUSTERFILE,">$folder/CLUSTERFILE.txt") || die "couldn't write into the file $folder/CLUSTERFILE.txt!\n";
print CLUSTERFILE "ENV:DETAILDIFFERENCE:ELEMENTS:NormalizeENV\n";
%hashResult=();		
%hashDifference=();		
%hash_pair_Score=();
%hashBlock=();

open (SCORES,"$folder/input.txt") || die "ERROR: CEBA couldn't open the file $folder/input.txt";
while ($line =<SCORES>){
	if ($line =~ /^Unicity/){}
	else{
		if ($line =~ /^(\s)*$/){}
		else{
			@scoreData=();
			chomp $line;
			@scoreData=split(" ",$line);
			$hash_pair_Score{$scoreData[0]}{$scoreData[1]}=$scoreData[2];
			
			
		}
	}
}	
close(SCORES);

@keys=();
@keys = keys %hashBlock;

%hashBlock=();
@keysA=();
@keysA = sort keys %hash_pair_Score;
$indexblockA=0;

while ($indexblockA <(scalar @keysA)){
	$blockA=$keysA[$indexblockA];	
	
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
			@keysB = sort keys %{$hash_pair_Score{$blockA}};
			$NumberBlocks=scalar @keysB;
			foreach $block(@keysB){
					if($hash_pair_Score{$blockA}{$block} ne $hash_pair_Score{$blockB}{$block}){
						$differenceCount++;
						$difference=$difference." ".$indexA;
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
	
		$blockList="";
	}
	
	%hashDifference=();				
}#close BlockA


	
%hash_pair_Score=();
@keysRI =();
@keysRI = keys %hashResult;
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
		if($normalizedRessemblance >0){
			print CLUSTERFILE "$ratio:".$hashResult{$cluster}.":$cluster".":"."$normalizedRessemblance\n";
		}
}
%hashResult=();			


close (CLUSTERFILE);
		
exit;
