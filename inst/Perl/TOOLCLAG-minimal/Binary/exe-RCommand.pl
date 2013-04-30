#!/usr/bin/perl -s

$SUBpath= $f;
$parameter= $k;

    	
if ($verbose) {
	print "\n\nJOB SUMMARY\n";
	print "Folder: $SUBpath\n";

	print "-----------------------------------\n\n";
	print "DEBUG: STEP1: Cluster...";	
}
system($^X, "./Binary/1-CoEvScoring.pl", $SUBpath) == 0 || die "1-CoEvScoring.pl failed";
	if ($verbose) {
	print "OK\n";
}

#	print "DEBUG: STEP2: CLAG displays matrix...";		
#	system "./Binary/2-MatrixNONClusterized.pl $SUBpath  ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG_STEP1.txt";
#	print "OK\n";
#
#	print "DEBUG: STEP3: CLAG displays matrix Clusterized...";		
#	system "./Binary/3-MatrixClusterized.pl $SUBpath  ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG_STEP2.txt";
#	print "OK\n";
#	
#	print "DEBUG: STEP4: CLAG displays matrix clusterized  \"environment score\"=1...";		
#	system "./Binary/4-MatrixClusterizedParam.pl $SUBpath  ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized-Scores1.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG_STEP3.txt";
#	print "OK\n";
#	

if ($verbose) {
	print "DEBUG: STEP5: Cluster aggregate...";	
}
system($^X, "./Binary/Aggregation.pl", $SUBpath, "aggregation", $parameter) == 0 || die "Aggregation.pl failed";
if ($verbose) {
	print "OK\n";
}
#	
#	print "DEBUG: STEP6: Draw graph...";
#	system "./Binary/5-CallNeato.pl $SUBpath $parameter";
#	print "OK\n";
#	print "DEBUG: STEP7: CLAG displays matrix Clusterized -aggregated ...";		
#	system "./Binary/3-MatrixClusterizedAggregation.pl $SUBpath aggregation.txt ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Aggregated.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG_STEP4.txt";
#	print "OK\n";

exit 0;

