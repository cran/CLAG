#!/usr/bin/perl -s
use File::Find;
use Getopt::Std;
use Time::HiRes qw/gettimeofday/;
getopts("f:k:d");

$path= $f;
$parameter= $k;
$delta= $d;

 
$exp="input.txt";
$SUBpath="";
sub recherche {
  if (-f){
    push(@acronyme,"$File::Find::dir/$_")
    if $_=~/$exp$/;
  }
}


@acronyme=();
$SUBpath="";
find(\&recherche,"$path");
foreach $acro (@acronyme)
{
	
	
	$SUBpath=substr($acro, 0,((length $acro)-10));
	if ($verbose) {
		print "\n\nJOB SUMMARY\n";
		print "Folder: $SUBpath\n";

		print "-----------------------------------\n\n";
	
		print "DEBUG: STEP1: Cluster...";	
		#my $clock0= gettimeofday();
	}
	system($^X, "./AnyMatrix/1-CoEvScoring.pl", $SUBpath, $delta) == 0 || die "1-CoEvScoring.pl failed";
	if ($verbose) {
		#my $clock1= gettimeofday();
		print "OK\n";
		#print "\n Time1: ".($clock1-$clock0)."s\n";
		print "DEBUG: STEP2: Cluster aggregate...";	
		#my $clock0= gettimeofday();
	}
	system($^X, "./AnyMatrix/Aggregation.pl", $SUBpath, "aggregation", $parameter, $delta) == 0 || die "Aggregation.pl failed";
	if ($verbose) {
		#my $clock1= gettimeofday();
		#print "\n Time2: ".($clock1-$clock0)."s\n";
		print "OK\n";
	}

	
#	print "DEBUG: STEP3: Draw graph...";
#	system "./AnyMatrix/5-CallNeato.pl $SUBpath $parameter $delta";
#	print "OK\n";
#		
#	print "DEBUG: STEP4: CLAG displays matrix...";		
#	system "./AnyMatrix/2-MatrixNONClusterized.pl $SUBpath ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG1.txt";
#	print "OK\n";
#
#	print "DEBUG: STEP5: CLAG displays matrix Clusterized...";		
#	system "./AnyMatrix/3-MatrixClusterized.pl $SUBpath  $delta";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG2.txt";
#	print "OK\n";
#
#	print "DEBUG: STEP6: CLAG displays matrix clusterized  \"environemental score\"=1...";		
#	system "./AnyMatrix/4-MatrixClusterizedParam.pl $SUBpath $delta ";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Clusterized-Scores1.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG3.txt";
#	print "OK\n";
#
#
#	
#	print "DEBUG: STEP7: CLAG displays matrix Clusterized -aggregated ...";		
#	system "./AnyMatrix/3-MatrixClusterizedAggregation.pl $SUBpath aggregation $delta";
#	$RCommandFile=$SUBpath."/"."R_COMMAND-Matrix-Aggregated.txt";
#	system "R --no-save < $RCommandFile > $SUBpath/DEBUG4.txt";
#	print "OK\n";	

} 

exit 0;
	

	
	

	
	

