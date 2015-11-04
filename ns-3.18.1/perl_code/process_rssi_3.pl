for($m=4; $m < 12; $m++)
{

  $output_filename="results_total/"."Result_Total_"."$m".".txt";
  open(OUT0, ">$output_filename") ||die "Failed opening.\n";

  for($i=1; $i < 3; $i++)
  {
	 $input_filename="results_log"."$i"."/"."Itp_Result_"."$m".".txt";
	 open(IN, "$input_filename") ||die "Failed opening $input_filename.\n";

	 while($ref_txt=<IN>)
	 {
		print OUT0 "$ref_txt";
	 }
  }
}
