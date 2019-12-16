project="Lang"
start_fault=6
end_fault=6
trials=1
budget=120
project_dir=`pwd`

./generate_tests.sh $project $start_fault $end_fault $trials $budget $project_dir
