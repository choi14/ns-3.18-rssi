use Switch;

@period = (100, 1000, 10000, 100000, 1000000);
@doppler = (0.1, 0.5, 1);
@bound = (10, 30, 50);

for($type = 0; $type < 2; $type++){
	for($p = 0; $p < 5; $p++){
		for($d = 0; $d < 3; $d++){
			for($b = 0; $b < 3; $b++){
				
				$output_filename="result_151013/result_comb/"."comb_"."$type"."_"."$period[$p]"."_"."$doppler[$d]"."_"."$bound[$b]".".txt";
				open(OUT, ">$output_filename") ||die "Failed opening.\n";
				
				for($seed = 1; $seed < 101; $seed++){
					$input_filename="result_151013/"."MRA_"."$seed"."_"."$type"."_"."$period[$p]"."_"."$doppler[$d]"."_"."$bound[$b]".".txt";
					open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

					while($ref_txt=<IN>)
					{
						if ($ref_txt =~ /Throughput/)
						{
							@ref=split(/Throughput /, $ref_txt);
							chomp(@ref);
							@thr = split(/ Mb/, $ref[1]);
							chomp(@thr);
							#thr[0] = throughput
						}
						elsif ($ref_txt =~ /PER/)
						{
							@per=split(/PER /, $ref_txt);
							chomp(@ref);
							#per[1] = PER
						}
					}
					print OUT "$thr[0] $per[1]"; 
				}
			}
		}
	}
}





