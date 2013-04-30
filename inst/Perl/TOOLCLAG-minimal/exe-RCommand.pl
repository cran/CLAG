#!/usr/bin/perl -s
 
$path= $f;
$program= $p;
if($k){
$parameter= $k;
}else{
$parameter= 0;
}
if($d){
$delta= $d;
}else{
$delta= "5/10/20/40";
}
if (!$verbose) {
	$verbose = 0;
}

if($program eq 1){
	if ($verbose) {
		print "GENERAL matrix\n";
	}
	system($^X, "-s", "./AnyMatrix/exe-RCommand.pl", "-f=$path", "-k=$parameter", "-d=$delta", "-verbose=$verbose") == 0 || die "failure";
}else{
	if($program eq 2){
		if ($verbose) {
			print "BINARY matrix\n";	
		}
		system($^X, "-s", "./Binary/exe-RCommand.pl", "-f=$path", "-k=$parameter", "-verbose=$verbose") == 0 || die "failure";
	}else{
		if($program eq 3){
			if ($verbose) {
				print "SPECIFIC matrix where N=M\n";
			}
			system($^X, "-s", "./SPECIFIC/exe-RCommand.pl" ,"-f=$path", "-k=$parameter", "-d=$delta", "-verbose=$verbose") == 0 || die "failure";
			
		}else{
			print "ERROR: Please specify -p=1, 2 or 3";
			exit 1;
		}
	}
}
exit 0;
	

