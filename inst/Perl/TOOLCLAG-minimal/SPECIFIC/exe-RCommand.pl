#!/usr/bin/perl -s

$SUBpath= $f;
$parameter= $k;
$delta= $d;

if ($verbose) {
	print "\n\nJOB SUMMARY\n";
	print "Folder: $SUBpath\n";
	print "-----------------------------------\n\n";

	print "DEBUG: STEP1: Cluster";	
}
system($^X, "./SPECIFIC/1-CoEvScoring.pl", $SUBpath, $delta) == 0 || die "1-CoEvScoring.pl failed";

if ($verbose) {
	print "OK\n";

	print "DEBUG: STEP2: Cluster aggregate...";	
}
system($^X, "./SPECIFIC/Aggregation.pl", $SUBpath, "aggregation", $parameter, $delta) == 0 || die "Aggregation.pl failed";
if ($verbose) {
	print "OK\n";
}

#	print "DEBUG: STEP3: CLAG displays matrix...";		
#	system "./SPECIFIC/2-MatrixNONClusterized.pl $SUBpath ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG1.txt";
#	print "OK\n";
#	
#	print "DEBUG: STEP4: CLAG displays matrix Clusterized...";		
#	system "./SPECIFIC/3-MatrixClusterized.pl $SUBpath  $delta";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG2.txt";
#	print "OK\n";
#	
#	print "DEBUG: STEP5: CLAG displays matrix clusterized sym= 1, env=1...";		
#	system "./SPECIFIC/4-MatrixClusterizedParam.pl $SUBpath $delta ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized-Scores1.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG3.txt";
#	print "OK\n";
#	
#	
#	print "DEBUG: STEP6: Draw graph...";
#	system "./SPECIFIC/5-CallNeato.pl $SUBpath $parameter $delta";
#	print "OK\n";
#	
#
#	print "DEBUG: STEP7: CLAG displays matrix Clusterized -aggregated ...";		
#	system "./SPECIFIC/3-MatrixClusterizedAggregation.pl $SUBpath aggregation $delta";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Aggregated.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG4.txt";
#	print "OK\n";

exit 0;
	
