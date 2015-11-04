#!/bin/bash

# Delete the 
sed 's/\//g' $1.in >& temp/$1Modified.in

# 150922 tjpark for debugging 
# 0: run w/o gdb
# 1: run w/  gdb
debug=0

for ((index=0; index<=6; index++))
do

	# Read text file
	count=0
	while read A B C D E F G
	do
		case ${index} in
			0)
				variable[$count]="$A"
				;;
			1)
				variable[$count]="$B"
				;;
			2)
				variable[$count]="$C"
				;;
			3)
				variable[$count]="$D"
				;;
			4)
				variable[$count]="$E"
				;;
			5)
				variable[$count]="$F"
				;;
			6)
				variable[$count]="$G"
				;;
		esac
		count=$(($count+1))
	done < temp/$1Modified.in

	Date="${variable[0]}"
	Version="${variable[1]}"
	Case="${variable[2]}"
	Scenario="${variable[3]}"
	StartSeed="${variable[4]}"
	EndSeed="${variable[5]}"
	SimulationTime="${variable[6]}"
	Lambda="${variable[7]}"
	Cot="${variable[8]}"
	TxOp="${variable[9]}"
	LaaCcaThreshold="${variable[10]}"
	WifiCcaEdThreshold="${variable[11]}"
	HarqTimeout="${variable[12]}"
	RlcReorderingTimeout="${variable[13]}"
	LbtCwsIncPolicy="${variable[14]}"
	LbtCwsResetPolicyConsecMaxCws="${variable[15]}"
	LbtCwsResetPolicyTimeout="${variable[16]}"
	LbtCwsIncFunc="${variable[17]}"
	LbtRatioBusyPeriodsThreshold="${variable[18]}"
	LbtRatioBusySlotsThreshold="${variable[19]}"
	CwsFixed="${variable[20]}"
	LbtRatioNackThreshold="${variable[21]}"

	# Make a directory
	if [ ! -d "$Date-result/ver$Version/resultData/" ]
	then
		mkdir -p $Date-result/ver$Version/resultData/
	fi

	for ((iter=$StartSeed; iter<=$EndSeed; iter++))
	do
		if [ ! -d "$Date-result/ver$Version/case_$Case/seed$iter/" ]
		then
			mkdir -p $Date-result/ver$Version/case_$Case/seed$iter/
		fi
	done

	# Execution scenario file
	case ${Scenario} in
		1)
			for ((iter=$StartSeed; iter<=$EndSeed; iter++))
			do
				echo "Date ${Date}"
				echo "Seed ${iter}"
				echo "Scenario A-${Scenario}"
				echo "SimulationTime ${SimulationTime} s"
				echo "Lambda ${Lambda} files/s"
				echo "TxOp ${TxOp} ms"
				echo "WifiCcaEdThreshold ${WifiCcaEdThreshold} dBm"
				echo " "

				if [ $debug -eq 0 ]
				then
					./waf --run "scratch/A-$Scenario-udp --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --wifiCcaEdThreshold=$WifiCcaEdThreshold --dir=$Date-result/ver$Version/case_$Case/seed$iter" >& $Date-result/ver$Version/case_$Case/seed$iter/log.log
				else
					./waf --run scratch/A-$Scenario-udp --command-template="gdb --args %s --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --wifiCcaEdThreshold=$WifiCcaEdThreshold --dir=$Date-debugResult/ver$Version/case_$Case/seed$iter"
				fi
			done
			;;

		2)
			for ((iter=$StartSeed; iter<=$EndSeed; iter++))
			do
				echo "Date ${Date}"
				echo "Seed ${iter}"
				echo "Version ${Version}"
        echo "Case ${Case}"
				echo "Scenario A-${Scenario}"
				echo "SimulationTime ${SimulationTime} s"
				echo "Lambda ${Lambda} files/s"
				echo "Cot ${Cot} ms"
				echo "TxOp ${TxOp} ms"
				echo "LaaCcaThreshold ${LaaCcaThreshold} dBm"
				echo "WifiCcaEdThreshold ${WifiCcaEdThreshold} dBm"
				echo "HarqTimeout ${HarqTimeout}"
				echo "RlcReorderingTimeout ${RlcReorderingTimeout}"
				echo "LbtCwsIncPolicy ${LbtCwsIncPolicy}"
				echo "LbtCwsResetPolicyConsecMaxCws ${LbtCwsResetPolicyConsecMaxCws}"
				echo "LbtCwsResetPolicyTimeout ${LbtCwsResetPolicyTimeout}"
				echo "LbtCwsIncFunc ${LbtCwsIncFunc}"
				echo "LbtRatioBusyPeriodsThreshold ${LbtRatioBusyPeriodsThreshold}"
				echo "LbtRatioBusySlotsThreshold ${LbtRatioBusySlotsThreshold}"
	      echo "LbtRatioNackThreshold ${LbtRatioNackThreshold}"
			  echo " "

			if [ $debug -eq 0 ]
			then
				./waf --run "scratch/A-$Scenario-udp --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --cot=$Cot --laaCcaThreshold=$LaaCcaThreshold --wifiCcaEdThreshold=$WifiCcaEdThreshold --harqTimeout=$HarqTimeout --rlcReorderingTimeout=$RlcReorderingTimeout --lbtCwsIncPolicy=$LbtCwsIncPolicy --lbtCwsResetPolicyConsecMaxCws=$LbtCwsResetPolicyConsecMaxCws --lbtCwsResetPolicyTimeout=$LbtCwsResetPolicyTimeout --lbtCwsIncFunc=$LbtCwsIncFunc --lbtRatioBusyPeriodsThreshold=$LbtRatioBusyPeriodsThreshold --lbtRatioBusySlotsThreshold=$LbtRatioBusySlotsThreshold --dir=$Date-result/ver$Version/case_$Case/seed$iter --cwsFixed=$CwsFixed --lbtRatioNackThreshold=$LbtRatioNackThreshold" >& $Date-result/ver$Version/case_$Case/seed$iter/log.log
			else
				./waf --run scratch/A-$Scenario-udp --command-template="gdb --args %s --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --cot=$Cot --laaCcaThreshold=$LaaCcaThreshold --wifiCcaEdThreshold=$WifiCcaEdThreshold --harqTimeout=$HarqTimeout --rlcReorderingTimeout=$RlcReorderingTimeout --lbtCwsIncPolicy=$LbtCwsIncPolicy --lbtCwsResetPolicyConsecMaxCws=$LbtCwsResetPolicyConsecMaxCws --lbtCwsResetPolicyTimeout=$LbtCwsResetPolicyTimeout --lbtCwsIncFunc=$LbtCwsIncFunc --lbtRatioBusyPeriodsThreshold=$LbtRatioBusyPeriodsThreshold --lbtRatioBusySlotsThreshold=$LbtRatioBusySlotsThreshold --dir=$Date-debugResult/ver$Version/case_$Case/seed$iter --cwsFixed=$CwsFixed --lbtRatioNackThreshold=$LbtRatioNackThreshold"
			fi
			done
			;;

		3)
			for ((iter=$StartSeed; iter<=$EndSeed; iter++))
			do
				echo "Seed ${iter}"
				echo "Version ${Version}"
        echo "Case ${Case}"
				echo "Scenario A-${Scenario}"
				echo "SimulationTime ${SimulationTime} s"
				echo "Lambda ${Lambda} files/s"
				echo "Cot ${Cot} ms"
				echo "LaaCcaThreshold ${LaaCcaThreshold} dBm"
				echo "HarqTimeout ${HarqTimeout} ms"
				echo "RlcReorderingTimeout ${RlcReorderingTimeout} ms"
				echo "LbtCwsIncPolicy ${LbtCwsIncPolicy}"
				echo "LbtCwsResetPolicyConsecMaxCws ${LbtCwsResetPolicyConsecMaxCws}"
				echo "LbtCwsResetPolicyTimeout ${LbtCwsResetPolicyTimeout}"
				echo "LbtCwsIncFunc ${LbtCwsIncFunc}"
				echo "LbtRatioBusyPeriodsThreshold ${LbtRatioBusyPeriodsThreshold}"
				echo "LbtRatioBusySlotsThreshold ${LbtRatioBusySlotsThreshold}"
	      echo "LbtRatioNackThreshold ${LbtRatioNackThreshold}"

			echo " "

			if [ $debug -eq 0 ]
			then
				./waf --run "scratch/A-$Scenario-udp --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --cot=$Cot --laaCcaThreshold=$LaaCcaThreshold --harqTimeout=$HarqTimeout --rlcReorderingTimeout=$RlcReorderingTimeout --lbtCwsIncPolicy=$LbtCwsIncPolicy --lbtCwsResetPolicyConsecMaxCws=$LbtCwsResetPolicyConsecMaxCws --lbtCwsResetPolicyTimeout=$LbtCwsResetPolicyTimeout --lbtCwsIncFunc=$LbtCwsIncFunc --lbtRatioBusyPeriodsThreshold=$LbtRatioBusyPeriodsThreshold --lbtRatioBusySlotsThreshold=$LbtRatioBusySlotsThreshold --dir=$Date-result/ver$Version/case_$Case/seed$iter --cwsFixed=$CwsFixed --lbtRatioNackThreshold=$LbtRatioNackThreshold" >& $Date-result/ver$Version/case_$Case/seed$iter/log.log
			else	
				./waf --run scratch/A-$Scenario-udp --command-template="gdb --args %s --seed=$iter --simulationTime=$SimulationTime --lambda=$Lambda --cot=$Cot --laaCcaThreshold=$LaaCcaThreshold --harqTimeout=$HarqTimeout --rlcReorderingTimeout=$RlcReorderingTimeout --lbtCwsIncPolicy=$LbtCwsIncPolicy --lbtCwsResetPolicyConsecMaxCws=$LbtCwsResetPolicyConsecMaxCws --lbtCwsResetPolicyTimeout=$LbtCwsResetPolicyTimeout --lbtCwsIncFunc=$LbtCwsIncFunc --lbtRatioBusyPeriodsThreshold=$LbtRatioBusyPeriodsThreshold --lbtRatioBusySlotsThreshold=$LbtRatioBusySlotsThreshold --dir=$Date-debugResult/ver$Version/case_$Case/seed$iter --cwsFixed=$CwsFixed --lbtRatioNackThreshold=$LbtRatioNackThreshold"
			fi
			done
			;;
	esac

	if [ $debug -eq 0 ]
	then
		if [ "$Date" != "" ] 
		then
			if [ "$1" == "sim1" ] || [ "$1" == "sim2" ] || [ "$1" == "sim3" ] || [ "$1" == "sim1-0" ] || [ "$1" == "sim1-1" ] || [ "$1" == "sim1-2" ] || [ "$1" == "sim1-3" ] || [ "$1" == "sim1-4" ] || [ "$1" == "sim1-5" ] || [ "$1" == "sim1-6" ] || [ "$1" == "sim1-7" ] || [ "$1" == "sim2-1" ] || [ "$1" == "sim2-2" ] || [ "$1" == "sim2-3" ] || [ "$1" == "sim2-4" ] || [ "$1" == "sim2-5" ] || [ "$1" == "sim2-6" ] || [ "$1" == "sim2-7" ] || [ "$1" == "sim3-1" ] || [ "$1" == "sim3-2" ] || [ "$1" == "sim3-3" ] || [ "$1" == "sim3-4" ] || [ "$1" == "sim3-5" ] || [ "$1" == "sim3-6" ] || [ "$1" == "sim3-7" ] || [ "$1" == "sim2-0" ] || [ "$1" == "sim3-0" ]
			then
				matlab -nodesktop -nosplash -r "CalcUPTandDelay('$1', $index);quit;"
			else
				/usr/local/MATLAB/R2012b/bin/matlab -nodesktop -nosplash -r "CalcUPTandDelay('$1', $index);quit;"
			fi
		fi
	fi

done
