#!/usr/bin/perl -w


$folder=shift;
$fileInput=shift;
$ecartVariable=shift;
@ecartVariableArray=split("/",$ecartVariable);
$index=0;
$fileCommand=$folder."/"."R_COMMAND-Matrix-Aggregated.txt";
open (FILEOUT_COMMAND, ">".$fileCommand)|| die "ERROR: CEBA couldn't write into the file $fileCommand";
	
while($index<scalar @ecartVariableArray){
	%hashCluster=();
	$ecart=$ecartVariableArray[$index];
	$indexCluster=1;
	open (FILE, "$folder/$fileInput-$ecart.txt")|| die "ERROR: CEBA couldn't open the file $folder/$fileInput-$ecart.txt";
	while ($line =<FILE>)
	{
		if ($line =~ /^ECART/ ){}
		elsif($line =~/^(\s)*$/ ){}
		else{
			chomp $line;
			@pairDataClusterValue=split(":",$line);
			
			$hashCluster{$indexCluster}=$pairDataClusterValue[0];
			$indexCluster++;
			
		}
	}
	
  	close(FILE);
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

			
		}
	}
  	close(FILE);
  	
  	

		
		@keysCluster =();
		@keysCluster = sort keys %hashCluster;

		$boolinserted=0;	
	
		$header="";
		$headerchanged="";
		$toWrite="";
	@keysA =();
		@keysA =  sort  keys %hashStoreScores;
		@keysB =();
		if((scalar @keysA )>0){
			@keysB =  sort  keys %{$hashStoreScores{$keysA[0]}};
		}

		foreach $blockB(@keysB){

		    $name=$blockB;
			$header=$header." \"E".$name."\"";
			if($headerchanged eq ""){
			$headerchanged="\"E".$name."\"";
			}else{
			$headerchanged=$headerchanged.",\"E".$name."\"";
			}
		}

		foreach   $cluster (@keysCluster){
	
			$blockList=$hashCluster{$cluster};
			@blocksSegemented=split(" ",$blockList);

			if($toWrite ne ""){
			$toWrite=$toWrite."0:$cluster ";
			@keysA =();
			@keysA =  sort  keys %hashStoreScores;
			@keysB =();
			
		
			
			if((scalar @keysA )>0){
			@keysB =  sort  keys %{$hashStoreScores{$keysA[0]}};
			}

			foreach $blockB(@keysB){					
					$toWrite=$toWrite."-2"." ";
				
			}
			$toWrite=$toWrite."\n"
			}
			foreach  $blockElement(@blocksSegemented){
			$name=$blockElement;
		 
				$toWrite=$toWrite."C".$cluster.":".$name." ";
				@keysB =();
				@keysB = sort  keys %{$hashStoreScores{$blockElement}};
				foreach $blockB(@keysB){
					if(exists 	$hashStoreScores{$blockElement} {$blockB}){		
						$toWrite=$toWrite.$hashStoreScores{$blockElement} {$blockB}." ";
						$boolinserted=1;
					}
					
				}
				$toWrite=$toWrite."\n";
				
			}
			
			
		}

		$file="$folder/PR-SCORING-output-Matrix-Aggregated-$ecart.txt";
		open (FILEOUT2, ">$file")|| die "ERROR: CEBA couldn't write into the file $file";
		print FILEOUT2 $header."\n".$toWrite;
		close(FILEOUT2);
		
		if ($boolinserted eq 1){
       print FILEOUT_COMMAND 
       "pdf(\"$folder/Matrix-Aggregated-$ecart.pdf\");\npotentials <- as.matrix(read.table(\"$file\", row.names=1, header=TRUE));\ncolorFun <- colorRampPalette(c(\"lightblue\",\"blue\",\"lightgreen\",\"darkgreen\",\"yellow\" ,\"orange\",\"red\", \"darkred\"));\n x<-c(0,0.04,0.08,0.12,0.16,0.2,0.24,0.28,0.32,0.36,0.4,0.44,0.48,0.52,0.56,0.6,0.64,0.68,0.72,0.76,0.8,0.84,0.88,0.92,0.96,1);\n       \nlibrary(lattice) ;\nlevelplot(potentials,scales=list(tck=0, x=list(rot=90),cex=0.1), col.regions=colorFun, main=NULL, xlab=list(\"Key aggregates\", cex=1), ylab=list(\"Environment\", cex=1),aspect=\"iso\", at=x,cut=50);\ndev.off();\n";
}       
		


%hashStoreScores=();


$index++;
}
close(FILEOUT_COMMAND);		
exit;
