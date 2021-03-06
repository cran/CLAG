#!/usr/bin/perl -w


$folder=shift;
$filoutput=shift;
$parameter=shift;

$ecartVariable=shift;

@ecartVariableArray=split("/",$ecartVariable);
$index=0;


sub uniq {
    return keys %{{ map { $_ => 1 } @_ }};
}


$elements="";
while($index<scalar @ecartVariableArray){
%hashCluster=();
$ecart=$ecartVariableArray[$index];
open (FILE, "$folder/CLUSTERFILE-$ecart.txt")|| die "ERROR: CEBA couldn't open the file $folder/CLUSTERFILE-$ecart.txt";
while ($line =<FILE>)
{
	if ($line =~ /^DELTA/ ){}
	elsif($line =~/^(\s)*$/ ){}
	else{
		chomp $line;
		@pairDataClusterValue=split(":",$line);
		$content=$pairDataClusterValue[4];
		
		
		$scSYM=$pairDataClusterValue[5];
		$scENV=$pairDataClusterValue[6];
		if($scSYM>=$parameter and$scENV>=$parameter ){
		$hashCluster{$scSYM}{$scENV}{$content}=1;
		$elements=$elements." ".$content;
		}
	}
}
@array=split(" ",$elements);
@arrayNew=uniq(@array);

#$hashCluster{$scoreApp}{$content}=$sc;	????
#####################################
### merging cluster of same score ###
#####################################
#$scoreValues="1.0 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0.0";

@keysClustersSYM=reverse sort keys %hashCluster;
foreach $scoreSYM (@keysClustersSYM){
	@keysClustersENV=reverse sort keys %{$hashCluster{$scoreSYM}};
	foreach $scoreENV (@keysClustersENV){
	
	%hashToAgg=();
	foreach $elt(@arrayNew){
		$hashToAgg{$elt}=0; 
	}
	$indexAggregates=1;
	@keysScoreCluster= keys %{$hashCluster{$scoreSYM}{$scoreENV}};
	foreach $cluster1(@keysScoreCluster){
	#print "DEBUG1: $scoreSYM /$scoreENV: $cluster1\n";
		@aggData1=uniq (split(" ",$cluster1));
		$attribution="";
		foreach $eltCluster (@aggData1){
			if($hashToAgg{$eltCluster} !=0){
				$attribution=$attribution." ".$hashToAgg{$eltCluster};
			}
		}
		@arrayAttribution=split(" ",$attribution);
		$find=scalar @arrayAttribution;
		if($find==0){
			foreach $eltCluster (@aggData1){
				$hashToAgg{$eltCluster}=$indexAggregates;
			}
			$indexAggregates++;
		}
		else{
		if($find==1){
			foreach $eltCluster (@aggData1){
				$hashToAgg{$eltCluster}=$arrayAttribution[0];
			}
		}else{
		foreach $eltCluster (@aggData1){
			$hashToAgg{$eltCluster}=$indexAggregates;
		}
		foreach $eltCluster (@arrayNew){
			foreach $att (@arrayAttribution){
				if ($hashToAgg{$eltCluster} ==$att){
					$hashToAgg{$eltCluster}=$indexAggregates;
				}
			}
		}
		
		
		$indexAggregates++;
		}
		}
	}#FIN foreach cluster
	
	delete($hashCluster{$scoreSYM}{$scoreENV});
	%hashTemp=();
	foreach $elt(@arrayNew){
		#print "$elt/$hashToAgg{$elt}\n";
		if($hashToAgg{$elt} != 0){
		if(exists $hashTemp{$hashToAgg{$elt}}){
		$hashTemp{$hashToAgg{$elt}}=$hashTemp{$hashToAgg{$elt}}." ".$elt; 
		}else{
		$hashTemp{$hashToAgg{$elt}}=$elt; 
		}
		}
	}
	@keytemp=keys %hashTemp;
	foreach $clustIndex(@keytemp){
		$clust=$hashTemp{$clustIndex};
		#print "DEBUG2: $score $clustIndex \n";
		$hashCluster{$scoreSYM}{$scoreENV}{$clust}="$scoreSYM:$scoreENV";
	}
	}
}



###############################################################
### finding key aggregates  while merging with the rest     ###
###############################################################
%hashToAgg=();
foreach $elt(@arrayNew){
	$hashToAgg{$elt}=0; 
}
$indexAggregates=1;
@keysClustersSYM=reverse sort keys %hashCluster;
foreach $scoreSYM (@keysClustersSYM){
@keysClustersENV =reverse sort keys %{$hashCluster{$scoreSYM}};
foreach $scoreENV (@keysClustersENV){
	
	@keysScoreCluster= keys %{$hashCluster{$scoreSYM}{$scoreENV}};
	foreach $cluster(@keysScoreCluster){	
#	print "DEBUG :".$score."/".$cluster."\n";
		#print "DEBUG: $cluster \n";
		@aggData1=split(" ",$cluster);
		$attribution="";
		foreach $eltCluster (@aggData1){
			if($hashToAgg{$eltCluster} !=0){
				$attribution=$attribution." ".$hashToAgg{$eltCluster};
			}
		}
		@arrayAttribution=uniq (split(" ",$attribution));
		$find=scalar @arrayAttribution;
		if($find==0){
			foreach $eltCluster (@aggData1){
				$hashToAgg{$eltCluster}=$indexAggregates;
			}
			$hashkeyAggregateScoreFirst{$indexAggregates}="$scoreSYM:$scoreENV";
			$hashkeyAggregateScoreLast{$indexAggregates}="$scoreSYM:$scoreENV";
			$indexAggregates++;
			#print "case 1\n"
		}
		else{
			if($find==1){
				foreach $eltCluster (@aggData1){
					if($hashToAgg{$eltCluster} ==0){
					$hashToAgg{$eltCluster}=$arrayAttribution[0];
					}
				}
				$hashkeyAggregateScoreLast{$arrayAttribution[0]}="$scoreSYM:$scoreENV";
					#print "case 2 /".$attribution."/".$arrayAttribution[0]."\n"
			}else{
			foreach $eltCluster (@aggData1){
				if($hashToAgg{$eltCluster} ==0){
					$hashToAgg{$eltCluster}=$indexAggregates;
				}
			}
			$hashkeyAggregateScoreFirst{$indexAggregates}="$scoreSYM:$scoreENV";
			$hashkeyAggregateScoreLast{$indexAggregates}="$scoreSYM:$scoreENV";
			$indexAggregates++;
				#print "case 3\n"
			}
			}
			
	}#FIN foreach cluster	

}
}

$hashTemp=();
foreach $elt(@arrayNew){
	if(exists $hashkeyAggregate{$hashToAgg{$elt}}){
		$hashkeyAggregate{$hashToAgg{$elt}}=$hashkeyAggregate{$hashToAgg{$elt}}." ".$elt; 
	}else{
		$hashkeyAggregate{$hashToAgg{$elt}}=$elt; 
	}
}

@keyresAgg=sort keys %hashkeyAggregate;
foreach $aggresIndex(@keyresAgg){
	$res =$hashkeyAggregate{$aggresIndex};
	$hashSort{$hashkeyAggregateScoreFirst{$aggresIndex}}{$hashkeyAggregateScoreLast{$aggresIndex}}{$res}=$aggresIndex;
}


$id=1;
open (SCORES,">$folder/$filoutput-$ecart.txt") || die "ERROR: CEBA couldn't open the file $folder/$filoutput";
@keySF=reverse sort keys %hashSort;
foreach $sf(@keySF){
@keySL=reverse sort keys %{$hashSort{$sf}};
foreach $sl(@keySL){
@keyAggD=reverse sort keys %{$hashSort{$sf}{$sl}};
foreach $agg(@keyAggD){

print SCORES   $agg.":".$id.":".$sf.":".$sl."\n";
$id++;
}
}
}
close (SCORES);



$index++;
}











exit;