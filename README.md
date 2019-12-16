# EvoSuiteFIT - Experiment Package

This repository is intended to allow replication and extension of the study
conducted in the following paper:

(Author Information Excluded for Double Blind Review). Learning How to 
Search: Generating Exception-Triggering Tests Through Adaptive Fitness 
Function Selection. Under submission to IEEE International Conference 
on Software Testing.

The original experiment was conducted on Amazon EC2 instances (t2.large) 
running Amazon Linux. Original development was conducted on Ubuntu 
Linux. We provide setup for both platforms. 

## Note for Reviewers

If you encounter any issues during your review, you may contact us using the 
Issues tab above (we will respond through the dummy account to maintain the 
blind status). 

## Setup

If you are on Amazon EC2:
`sudo ./setup_ec2.sh`

If you are on Ubuntu:
`sudo ./setup_ubuntu.sh`

Once the script is completed, it is recommended that you restart bash to 
ensure environmental variables are correctly set.

## Executing experiments

The script `run_experiment.sh` acts as a wrapper for the `generate_tests.sh` 
script. 

Edit the following values to match your goal:

`project=Chart`    : The project from Defects4J

`start_fault=1`    : First fault to generate tests for

`end_fault=26`      : The last fault to generate tests for

`trials=10`         : Number of repeats

`budget=600`        : The search budget (in seconds)

`project_dir`       : Where you are running the experiment from (default is 
the root directory of this repository)

Then, run:
`./run_experiment.sh`
