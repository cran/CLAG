#!/usr/bin/perl -w
$folder=shift;



$fileCommand=$folder."/"."R_COMMAND-Matrix.txt";
open (FILEOUT_COMMAND, ">".$fileCommand)|| die "ERROR: CEBA couldn't write into the file $fileCommand";


open (FILE, "$folder/input.txt")|| die "ERROR: CEBA couldn't open the file $folder/input.txt";
$file="$folder/PR-SCORING-output-Matrix.txt";
open (FILEOUT, ">$file")|| die "ERROR: CEBA couldn't write into the file $file";


while ($line =<FILE>)
{
	if($line =~/^(\s)*$/ ){}
	else{
	
		chomp $line;
		@pairDataScore=split(" ",$line);
	
		$b1 = $pairDataScore[0];
		$b2 = $pairDataScore[1];
		
		$hashStoreScores{$b1}{$b2}=$pairDataScore[2];

		
	}
}
close(FILE);

@keysA =();
			@keysA =  sort {$a <=> $b} keys %hashStoreScores;
			@keysB =();
			if((scalar @keysA )>0){
			@keysB =  sort {$a <=> $b} keys %{$hashStoreScores{$keysA[0]}};
			}
$BlocsLabelValue="";
@keys =();
@keys = sort{$a<=>$b}keys %hashStoreScores;
$counterBlock=scalar @keys ;
foreach  $block(@keysB){
	$BlocsLabelValue=$BlocsLabelValue." \"E".$block."\"";
}
print FILEOUT $BlocsLabelValue."\n";	


@keysA =();
@keysA = sort {$a<=>$b} keys %hashStoreScores;
$counterBlock=scalar @keysA ;
$boolinserted=0;
foreach  $blockA(@keysA){
	@keysB =();
	@keysB = sort {$a<=>$b} keys %{$hashStoreScores{$blockA}};
	
	print FILEOUT "\"$blockA\" ";	
	foreach $blockB(@keysB){
		#print $blockA." ".$blockB."\n";
		print FILEOUT $hashStoreScores{$blockA}{$blockB}." ";	
		$boolinserted=1;
	}
	print FILEOUT "\n"
}
close(FILEOUT);


if ($boolinserted eq 1){
	print FILEOUT_COMMAND "pdf(\"$folder/Matrix.pdf\");\npotentials <- as.matrix(read.table(\"$file\", row.names=1, header=TRUE));\ncolorFun <- colorRampPalette(c(\"lightblue\",\"blue\",\"lightgreen\",\"darkgreen\",\"yellow\" ,\"orange\",\"red\", \"darkred\"));\n x<-c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.14,0.16,0.18,0.2,0.22,0.24,0.26,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.52,0.54,0.56,0.58,0.6,0.62,0.64,0.66,0.68,0.7,0.72,0.74,0.76,0.78,0.8,0.82,0.84,0.86,0.88,0.9,0.92,0.94,0.96,0.98,1);\n	\nlibrary(lattice) ;\nlevelplot(potentials,scales=list(tck=0, x=list(rot=90),cex=0.1), col.regions=colorFun, main=NULL, xlab=list(\"data\", cex=1), ylab=list(\"Environment\", cex=1),aspect=\"iso\", at=x,cut=50);\ndev.off();\n";
}	
%hashStoreScores=();
	
close(FILEOUT_COMMAND);
exit;
