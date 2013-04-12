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

my $res = 1;

if($program eq 1){
	if ($verbose) {
		print "GENERAL matrix\n";
	}
	$res = system($^X, "./AnyMatrix/exe-RCommand.pl", "-f=$path", "-k=$parameter", "-d=$delta", "-verbose=$verbose");
}else{
	if($program eq 2){
		if ($verbose) {
			print "BINARY matrix\n";	
		}
		$res = system($^X, "./Binary/exe-RCommand.pl", "-f=$path", "-k=$parameter", "-verbose=$verbose");
	}else{
		if($program eq 3){
			if ($verbose) {
				print "SPECIFIC matrix where N=M\n";
			}
			$res = system($^X, "./SPECIFIC/exe-RCommand.pl" ,"-f=$path", "-k=$parameter", "-d=$delta", "-verbose=$verbose");
			
		}else{
			print "ERROR: Please specify -p=1, 2 or 3";
			exit 1;
		}
	}
}
exit $res;
	

