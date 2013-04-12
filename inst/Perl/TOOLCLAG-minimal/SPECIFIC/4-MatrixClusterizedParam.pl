#!/usr/bin/perl -w


$folder=shift;
$ecartVariable=shift;

$fileCommand=$folder."/"."R_COMMAND-Matrix-Clusterized-Scores1.txt";
open (FILEOUT_COMMAND, ">".$fileCommand)|| die "ERROR: CEBA couldn't write into the file $fileCommand";


@ecartVariableArray=split("/",$ecartVariable);
$index=0;
while($index<scalar @ecartVariableArray){
	$indexDelta=$ecartVariableArray[$index];

	
	
	$indexCluster=1;
	open (FILE, "$folder/CLUSTERFILE-$indexDelta.txt")|| die "ERROR: CEBA couldn't open the file $folder/CLUSTERFILE-$indexDelta.txt";
	while ($line =<FILE>)
	{
		
		#print $line;
		if ($line =~ /^DELTA/ ){}
		elsif($line =~/^(\s)*$/ ){}
		else{
			chomp $line;
			@pairDataClusterValue=split(":",$line);
			if($pairDataClusterValue[5] eq 1 and $pairDataClusterValue[6] eq 1){
			$hashCluster{$indexDelta}{$indexCluster}=$pairDataClusterValue[4];
			$indexCluster++;
			}
		}
	}
	
  	close(FILE);
	$index++;
}



	open (FILE, "$folder/input.txt")|| die "ERROR: CEBA couldn't open the file $folder/input.txt";
	
	while ($line =<FILE>)
	{
		if ($line =~ /^Unicity/ ){}
		elsif($line =~/^(\s)*$/ ){}
		else{
			@pairDataScore=split(" ",$line);
			$b1 = $pairDataScore[0];
			$b2 = $pairDataScore[1];
		
			$hashStoreScores{$b1}{$b2}=$pairDataScore[2];
			$hashStoreScores{$b2}{$b1}=$pairDataScore[2];
			$hashStoreScores{$b1}{$b1}=1;
			$hashStoreScores{$b2}{$b2}=1;
			
		}
	}
  	close(FILE);
  	
  	

@ecartVariableArray=split("/",$ecartVariable);
$index=0;
while($index<scalar @ecartVariableArray){
	$indexDelta=$ecartVariableArray[$index];

	
		
		@keysCluster =();
		@keysCluster = sort keys %{$hashCluster{$indexDelta}};
		$boolinserted=0;	
	
		$header="";
		$headerchanged="";
		$toWrite="";
		@keysB =();
		@keysB =  sort {$a <=> $b} keys %hashStoreScores;
		foreach $blockB(@keysB){
		    $name=$blockB;
			$header=$header." \"".$name."\"";
			if($headerchanged eq ""){
			$headerchanged="\"".$name."\"";
			}else{
			$headerchanged=$headerchanged.",\"".$name."\"";
			}
		}
	
		foreach  $cluster (@keysCluster){
		
			$blockList=$hashCluster{$indexDelta}{$cluster};
			@blocksSegemented=split(" ",$blockList);
			if($toWrite ne ""){
			$toWrite=$toWrite."0:$cluster ";
			@keysB =();
			@keysB = sort {$a <=> $b} keys %hashStoreScores;
			foreach $blockB(@keysB){
				if(exists 	$hashStoreScores{$blockB}){									
					$toWrite=$toWrite."-2"." ";
				}
			}
			$toWrite=$toWrite."\n"
			}
			foreach  $blockElement(@blocksSegemented){
			$name=$blockElement;
		 
				$toWrite=$toWrite."C".$cluster.":".$name." ";
				@keysB =();
				@keysB = sort {$a<=>$b} keys %{$hashStoreScores{$blockElement}};
				foreach $blockB(@keysB){
					if(exists 	$hashStoreScores{$blockElement} {$blockB}){		
						$toWrite=$toWrite.$hashStoreScores{$blockElement} {$blockB}." ";
						$boolinserted=1;
					}
					
				}
				$toWrite=$toWrite."\n";
				
			}
			
			
		}
		
		$file="$folder/PR-SCORING-output-Matrix-Clusterized-$indexDelta-Scores1.txt";
		open (FILEOUT2, ">$file")|| die "ERROR: CEBA couldn't write into the file $file";
		print FILEOUT2 $header."\n".$toWrite;
		close(FILEOUT2);
		
		if ($boolinserted eq 1){
		print FILEOUT_COMMAND "pdf(\"$folder/Matrix-Clusterized-$indexDelta-Scores1.pdf\");\n potentials <- as.matrix(read.table(\"$file\", row.names=1, header=TRUE));\ncolorFun <- colorRampPalette(c(\"lightblue\",\"blue\",\"lightgreen\",\"darkgreen\",\"yellow\" ,\"orange\",\"red\", \"darkred\"));\n	x<-c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.14,0.16,0.18,0.2,0.22,0.24,0.26,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.52,0.54,0.56,0.58,0.6,0.62,0.64,0.66,0.68,0.7,0.72,0.74,0.76,0.78,0.8,0.82,0.84,0.86,0.88,0.9,0.92,0.94,0.96,0.98,1);\n	colnames(potentials)<-c($headerchanged);	\nlibrary(lattice) ;		\nlevelplot(potentials,scales=list(tck=0, x=list(rot=90),cex=0.1), col.regions=colorFun,cuts = 50, main=NULL, xlab=list(\" Clusters\", cex=1), ylab=list(\"Environment\", cex=1),at=x,aspect=\"iso\",colorkey=list(space=\"right\",labels=list(cex=0.1)));		\ndev.off();		\n";
		}
		#print $indexDelta."\n";
		$index++;
		
	}	
	
close(FILEOUT_COMMAND);

%hashStoreScores=();
		
exit;
