use Switch;

@period = (100, 1000, 10000, 100000, 1000000);
@doppler = (0.1, 0.5, 1);
@bound = (10, 30, 50);

for($type = 0; $type < 2; $type++){
		for($d = 0; $d < 3; $d++){
			for($b = 0; $b < 3; $b++){
				$output_filename="result_151013/result_avg/"."avg_"."$type"."_"."$doppler[$d]"."_"."$bound[$b]".".txt";
				open(OUT, ">$output_filename") ||die "Failed opening.\n";
				
				for($p = 0; $p < 5; $p++){
				$input_filename="result_151013/result_comb/"."comb_"."$type"."_"."$period[$p]"."_"."$doppler[$d]"."_"."$bound[$b]".".txt";
				open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

				$thr = 0;
				$per = 0;
				$count = 0;
				$avg_thr = 0;
				$avg_per = 0;

				while($ref_txt=<IN>)
				{
					@data=split(/\s+/, $ref_txt);
					$thr += $data[0];
					$per += $data[1];
					$count++;
				}

				$avg_thr = $thr/$count;
				$avg_per = $per/$count;

				print OUT "$period[$p] $avg_thr $avg_per\n"; 
			}
		}
	}
}





