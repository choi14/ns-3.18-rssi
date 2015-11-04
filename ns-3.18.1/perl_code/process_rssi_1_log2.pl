use Switch;

$output_filename="results_log2/"."Result_4.txt";
open(OUT4, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_5.txt";
open(OUT5, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_6.txt";
open(OUT6, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_7.txt";
open(OUT7, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_8.txt";
open(OUT8, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_9.txt";
open(OUT9, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_10.txt";
open(OUT10, ">$output_filename") ||die "Failed opening.\n";
$output_filename="results_log2/"."Result_11.txt";
open(OUT11, ">$output_filename") ||die "Failed opening.\n";

for ($id=0; $id <10; $id++){
  $input_filename="log2/"."log_"."$id".".txt";

  open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

  while($ref_txt=<IN>)
  {
	 if ($ref_txt =~ /skb type/){
		@ref=split(/seq:/, $ref_txt);
		chomp(@ref);
		@data = split(/id:/, $ref[1]);
		chomp(@data);
      @data1 = split(/mcs:/, $data[1]);
		chomp(@data1);
		@data2 = split(/rssi:/, $data1[1]);
		chomp(@data2);
		@seq = split(/\s+/, $data[0]);
		chomp(@seq);
		@mcs = split(/\s+/, $data2[0]);
		chomp(@mcs);
		@rssi = split(/\s+/, $data2[1]);
		chomp(@rssi);
	
		switch ($mcs[1]){
		  case 4 {print OUT4 "$seq[1] $rssi[1]\n"; }
	     case 5 {print OUT5 "$seq[1] $rssi[1]\n"; }
	     case 6 {print OUT6 "$seq[1] $rssi[1]\n"; }
	     case 7 {print OUT7 "$seq[1] $rssi[1]\n"; }
	     case 8 {print OUT8 "$seq[1] $rssi[1]\n"; }
		  case 9 {print OUT9 "$seq[1] $rssi[1]\n"; }
		  case 10 {print OUT10 "$seq[1] $rssi[1]\n"; }
		  case 11 {print OUT11 "$seq[1] $rssi[1]\n"; }
		 }
	 }
  }
}	  

