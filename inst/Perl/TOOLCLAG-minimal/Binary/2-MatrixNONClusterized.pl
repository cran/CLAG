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
	$BlocsLabelValue=$BlocsLabelValue." \"".$block."\"";
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
	print FILEOUT_COMMAND "pdf(\"$folder/Matrix.pdf\");\npotentials <- as.matrix(read.table(\"$file\", row.names=1, header=TRUE));\ncolorFun <- colorRampPalette(c(\"blue\",\"red\"));\n x<-c(0,0.5,1);\n	\nlibrary(lattice) ;\nlevelplot(potentials,scales=list(tck=0, x=list(rot=90),cex=0.1), col.regions=colorFun, main=NULL, xlab=list(\"data\", cex=1), ylab=list(\"Environment\", cex=1),aspect=\"iso\", at=x,cut=2);\ndev.off();\n";
}	
%hashStoreScores=();
	
close(FILEOUT_COMMAND);
exit;
