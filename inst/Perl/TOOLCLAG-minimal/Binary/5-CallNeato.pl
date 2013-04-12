#!/usr/bin/perl -w
use POSIX;

$folder=shift;
$parameter=shift;
@colors = ("aliceblue","antiquewhite","aquamarine","azure","beige","bisque","black","blanchedalmond","blue","blueviolet","brown","burlywood","cadetblue","chartreuse","chocolate","coral","cornflowerblue","cornsilk","crimson","cyan","darkblue","darkcyan","darkgoldenrod","darkgray","darkgreen","darkgrey","darkkhaki","darkmagenta","darkolivegreen","darkorange","darkorchid","darkred","darksalmon","darkseagreen","darkslateblue","darkslategray","darkslategrey","darkturquoise","darkviolet","deeppink","deepskyblue","dimgray","dimgrey","dodgerblue","firebrick","floralwhite","forestgreen","fuchsia","gainsboro","ghostwhite","gold","goldenrod","gray","grey","green","greenyellow","honeydew","hotpink","indianred","indigo","ivory","khaki","lavender","lavenderblush","lawngreen","lemonchiffon","lightblue","lightcoral","lightcyan","lightgoldenrodyellow","lightgray","lightgreen","lightgrey","lightpink","lightsalmon","lightseagreen","lightskyblue","lightslategray","lightslategrey",
"lightsteelblue","lightyellow","lime","limegreen","linen","magenta","maroon","mediumaquamarine","mediumblue","mediumorchid","mediumpurple","mediumseagreen","mediumslateblue","mediumspringgreen","mediumturquoise","mediumvioletred","midnightblue","mintcream","mistyrose","moccasin","navajowhite","navy","oldlace","olive","olivedrab","orange","orangered","orchid","palegoldenrod","palegreen","paleturquoise","palevioletred","papayawhip","peachpuff","peru","pink","plum","powderblue","purple","red","rosybrown","royalblue","saddlebrown","salmon","sandybrown","seagreen","seashell","sienna","silver","skyblue","slateblue","slategray","slategrey","snow","springgreen","steelblue","tan","teal","thistle","tomato","turquoise","violet","wheat","white","whitesmoke","yellow","yellowgreen");

	open (CLUSTERFILE,"$folder/aggregation.txt") || die "couldn't open file $folder/aggregation.txt!";
	
		$numberNode=0;
	$indexColor=0;
	while($line=<CLUSTERFILE>){
		@lineContent=split(":",$line);
		$Clusterdata=$lineContent[0];
		@dataArray=sort split(" ",$Clusterdata);
		$index1=0;
		$numberNode=$numberNode+(scalar @dataArray);
		while ($index1< scalar (@dataArray)){
			$hash{$dataArray[$index1]}=$indexColor;
			
			$index1++;
		}
		$indexColor++;
	}		
	
	
	close (CLUSTERFILE);
	open (CLUSTEROUT,">$folder/GRAPH-aggregation.dot") || die "couldn't open file $folder/GRAPH-aggregation.dot!";
	print CLUSTEROUT "graph G{\n";
	@keyData=keys %hash;	
	foreach $element (@keyData){
		print CLUSTEROUT $element."[color=".$colors[$hash{$element}]."];\n";
	}
	open (CLUSTERFILE,"$folder/CLUSTERFILE.txt") || die "couldn't open file $folder/CLUSTERFILE.txt!";
	
	
	$line=<CLUSTERFILE>;
	while($line=<CLUSTERFILE>){
		@lineContent=split(":",$line);
		$Clusterdata=$lineContent[2];
		if($lineContent[3] >=$parameter){
		@dataArray=sort split(" ",$Clusterdata);
		$index1=0;
		while ($index1< scalar (@dataArray)){
			$index2=$index1+1;
			while ($index2< scalar (@dataArray)){
				$data1=$dataArray[$index1];
				$data2=$dataArray[$index2];
				if($hash{$data1} ne $hash{$data2} ){
				$hashRes{$data1."--".$data2}=" [color=grey];\n";
				}else{
				$hashRes{$data1."--".$data2}=" [color=".$colors[$hash{$data1}]."];\n";
				}
				$index2++;
			}
			$index1++;
		}
		}
	}		

	close (CLUSTERFILE);
	
	@keyRes=keys %hashRes;
	foreach $pair (@keyRes){
		print CLUSTEROUT $pair.$hashRes{$pair};
	}

	print CLUSTEROUT "}";
	close (CLUSTEROUT);
	if($numberNode <100){
		system "neato -Tpdf $folder/GRAPH-aggregation.dot -o $folder/GRAPH-aggregation.pdf";
	}
exit;
