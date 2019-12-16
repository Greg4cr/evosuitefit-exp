#!/bin/bash
# Generate tests and measure fault detection

# Set at command line
project=$1
start_fault=$2
end_fault=$3
trials=$4
budget=$5
project_dir=$6"/defects4j/framework/projects"
criteria="default exception"
approaches="UCB DSG_SARSA EVSNORL"

# Pre-configured
exp_dir=`pwd`
result_dir=$exp_dir"/results"
working_dir="/tmp"

mkdir $result_dir

# For each fault
for (( fault=$start_fault ; fault <= $end_fault ; fault++ )); do
    echo "--Fault: "$project"-"$fault
    mkdir $working_dir"/"$project"_"$fault

    # For each trial
    for (( trial=1; trial <= $trials ; trial++ )); do
        echo "----Trial: "$trial
        # For each approach
	for approach in $approaches; do
            # Generate EvoSuite tests
            echo "------Generating EvoSuite tests for "$approach

            # If this is not RL, run all selected criteria
	    if [ "$approach" == "EVSNORL" ]; then
                for criterion in $criteria; do
                    crinosc=`echo $criterion | sed 's/:/-/g'`
                    if [ -a $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$crinosc"/"$trial"/"$project"-"$fault"f-evosuite-"$crinosc"."$trial".tar.bz2" ]; then
                        echo "Suite already exists."
                    else
		        echo "--------Generating EvoSuite tests for "$criterion
                        perl defects4j/framework/bin/run_evosuite.pl -p $project -v $fault"f" -n $trial -o $result_dir"/suites/"$project"_"$fault"/"$budget -c $criterion -h $approach -b $budget -t $working_dir"/"$project"_"$fault -a 450
                        # Detect and remove non-compiling tests
		        echo "--------Removing non-compiling tests"
		        perl defects4j/framework/util/fix_test_suite.pl -p $project -d $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$crinosc"/"$trial -t $working_dir"/"$project"_"$fault
                        # Measure fault detection
                        echo "--------Measuring fault detection"
                        perl defects4j/framework/bin/run_bug_detection.pl -p $project -d $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$crinosc"/"$trial -o $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$crinosc -f "**/*Test.java" -t $working_dir"/"$project"_"$fault
                    fi 
 		done
            else
                if [ -a $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach"/"$trial"/"$project"-"$fault"f-evosuite-"$approach"."$trial".tar.bz2" ]; then
                    echo "Suite already exists."
                else
                    perl defects4j/framework/bin/run_evosuite.pl -p $project -v $fault"f" -n $trial -o $result_dir"/suites/"$project"_"$fault"/"$budget -c "method" -h $approach -b $budget -t $working_dir"/"$project"_"$fault -a 450
                    # Move files to proper name
	    	    mv $result_dir"/suites/"$project"_"$fault"/"$budget"/logs/"$project"."$fault"f.method."$trial".log" $result_dir"/suites/"$project"_"$fault"/"$budget"/logs/"$project"."$fault"f."$approach"."$trial".log"
                    mkdir $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach
                    mkdir $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach"/"$trial
	    	    mv $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-method/"$trial"/"$project"-"$fault"f-evosuite-method."$trial".tar.bz2" $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach"/"$trial"/"$project"-"$fault"f-evosuite-"$approach"."$trial".tar.bz2"
                    # Detect and remove non-compiling tests
    	  	    echo "--------Removing non-compiling tests"
   		    perl defects4j/framework/util/fix_test_suite.pl -p $project -d $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach"/"$trial -t $working_dir"/"$project"_"$fault
                    # Measure fault detection
                    echo "--------Measuring fault detection"
                    perl defects4j/framework/bin/run_bug_detection.pl -p $project -d $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach"/"$trial -o $result_dir"/suites/"$project"_"$fault"/"$budget"/"$project"/evosuite-"$approach -f "**/*Test.java" -t $working_dir"/"$project"_"$fault
                fi
            fi
        done
    done
    rm -rf $working_dir"/"$project"_"$fault 
done
