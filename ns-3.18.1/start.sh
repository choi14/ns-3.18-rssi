#!/bin/bash

clear


iter_start=$1
iter_end=$2

for seed in $(seq $iter_start $iter_end)
do
	for mode  in 0 1
	do
		for period in 100 1000 10000 100000 1000000 
		do
			for doppler in 0.1 0.5 1
			do
				for bound in 10 30 50
				do
					./waf --run "scratch/test --Seed=$seed --Type=$mode --Period=$period --Doppler=$doppler --Bound=$bound"
				done
			done
		done
	done
done

