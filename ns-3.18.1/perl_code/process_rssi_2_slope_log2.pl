#!/usr/local/bin/perl

for($m=4; $m < 12; $m++)
{
  $output_filename="results_log2/"."Itp_Result_"."$m".".txt";
  open(OUT0, ">$output_filename") ||die "Failed opening.\n";

  $input_filename="results_log2/"."/Result_"."$m".".txt";
  open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

  $ref_txt=<IN>;
  @data = split(/\s+/, $ref_txt);
  chomp(@data);
  $pre_seq = $data[0];
  $pre_rssi = $data[1];
  $interval = 10;
  $final_seq = 19;
  $step_total_count = 0;
  $step_zero_count = 0;

  
  if($pre_seq != 0)
  {
	 for($i=0; $i < $pre_seq; $i++)
	 {
		print OUT0 "$pre_rssi 1\n";
	 }
  }

  print OUT0 "$pre_rssi 0\n";

  while($ref_txt=<IN>)
  {
	 @data = split(/\s+/, $ref_txt);
	 chomp(@data);
	 $seq = $data[0];
	 $rssi = $data[1];

	 if($pre_seq < $seq){
		if($seq - $pre_seq != 1){
		  $step_total_count++;
		  $seq_diff = $seq-$pre_seq;
		  $rssi_diff = $rssi-$pre_rssi;
		  $step = $rssi_diff/$seq_diff;

		  if($step == 0){
			 $step_zero_count++;
		  }

		  for($n=1; $n < $seq_diff; $n++){
			 $n_rssi = $pre_rssi + $n*$step;
			 $n_rssi_int = int($n_rssi-0.5);
			 print OUT0 "$n_rssi_int 1\n"
		  }

		  print OUT0 "$rssi 0\n";
		  $pre_seq = $seq;
		  $pre_rssi = $rssi;
		}
		else{
		  print OUT0 "$rssi 0\n";
		  $pre_seq = $seq;
		  $pre_rssi = $rssi;
		}
	 }

	 # pre_seq > seq
	 else{
		if($pre_seq != $final_seq){
		  if($final_seq - $pre_seq > $interval){
			 if($step < 0){
				for($i=0; $i < $interval; $i++)
				{
				  $i_rssi = $pre_rssi + $i*$step;
				  print OUT0 "$i_rssi 1\n";
				}
			 }

			 # step > 0
			 else{
				for($i=0; $i < $interval; $i++){
				  print OUT0 "$pre_rssi 1\n";
				}
			 }
		  }
		
		  # $final_seq - $pre_seq < $interval
		  else{
			 if($step < 0){
				for($i=0; $i < $final_seq - $pre_seq; $i++){
				  $i_rssi = $pre_rssi + $i*$step;
				  print OUT0 "$i_rssi 1\n";
				}
			 }
			 else 
			 {
				for($i=0; $i < $final_seq - $pre_seq; $i++){
				 print OUT0 "$pre_rssi 1\n";
				}
			 }
		  }
		}

		if($seq != 0){
		  if($seq > $interval){
			 if($step < 0){
				for($i=0; $i < $interval; $i++)
				{
				  $i_rssi = $pre_rssi + $i*$step;
				  print OUT0 "$i_rssi 1\n";
				}
			 }

			 # $step > 0
			 else{
				for($i=0; $i < $interval; $i++){
				  print OUT0 "$pre_rssi 1\n";
				}
			 }
		  }

		  # $seq < $interval
		  else{
			 if($step <0){
				for($i=0; $i < $seq; $i++){
				  $i_rssi = $pre_rssi + $i*$step;
				  print OUT0 "$i_rssi 1\n";
				}
			 }

			 else {
				for($i=0; $i < $seq; $i++){
				  print OUT0 "$pre_rssi 1\n";
				}
			 }
		  }
		}

		print OUT0 "$rssi 0\n";
		$pre_seq = $seq;
		$pre_rssi = $rssi;
	 }
  }

  #final line of RSSI log
  if($seq != $final_seq){
	 if($final_seq - $seq > $interval){
		if($step < 0){
		  for($i=0; $i < $interval; $i++) {
			 $i_rssi = $pre_rssi + $i*$step;
			 print OUT0 "$i_rssi 1\n";
		  }
		}

		# $step >0
		else{
		  for($i=0; $i < $interval; $i++){
			 print OUT0 "$pre_rssi 1\n";
		  }
		}
	 }
	
	 # $final_seq - $seq < $interval
	 else{
		if($step < 0){
		  for($i=0; $i < $final_seq - $seq; $i++){
			 $i_rssi = $pre_rssi + $i*$step;
			 print OUT0 "$i_rssi 1\n";
		  }
		}

		else{
		  for($i=0; $i < $final_seq - $seq; $i++){
			 print OUT0 "$pre_rssi 1\n";
		  }
		}

	 }
  }
  print "$step_zero_count $step_total_count \n";
}
