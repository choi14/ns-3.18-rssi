for($m=4; $m < 12; $m++)
{
  @count = ();
  @fail = ();

  $output_filename="final_results/"."Final_Result_"."$m".".txt";
  open(OUT0, ">$output_filename") ||die "Failed opening.\n";

  $input_filename="results_total/"."Result_Total_"."$m".".txt";
  open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

  while($ref_txt=<IN>)
  {
	 @data = split(/\s+/, $ref_txt);
	 chomp(@data);

	 $rssi = $data[0];
	 $num = $data[1];

	 if( -89 < $rssi && $rssi < -54)
	 {
		$count[$rssi +88] += 1;
		$fail[$rssi +88] += $num;
	 }
  }

  $count_len = @count;
  $fail_len = @fail;
  print "$count_len $fail_len\n";

  for($n=0; $n < $count_len; $n++)
  {
	 if($count[$n] > 150)
	 {
		$ratio = ($count[$n]-$fail[$n])/$count[$n];
		$ratio = sprintf "%.2f", $ratio;
		$n_rssi = $n-88;
		print OUT0 "$n_rssi $ratio\n";
	 }

  }
}
