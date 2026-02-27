#!/bin/sh

HW=01 # can be hardcoded in by commenting out the 3 lines below

# takes the HW number from the end of the working directory
SCRIPT_DIR="$PWD"
FOLDER_NAME="${SCRIPT_DIR##*/}"
HW=$(echo "$FOLDER_NAME" | sed 's/.*\(..\)$/\1/') # usable also in POSIX to extract last two char

#HW1="${FOLDER_NAME: -2 }" # usable in bash

PROGRAM_REF=./b3b36prg-hw$HW-genref
NC_PROGRAM_MY=main.c # my program not compiled
PROGRAM_MY=./a.out
COMPILATOR=gcc

# used as bool
correct=1
hex_mode=0
random_mode=0
valgrind=""
compile=0

# get the flags and make the corresponding vars true 
# -x for hex and -r for randomly generated inputs from them
while getopts "xrvc" flag; do
    case "${flag}" in
        x) echo "Hex mode on" 
            hex_mode=1 ;;
        r) echo "Random mode on" 
            random_mode=1 ;;
        v) echo "Valgrind on"
            valgrind="valgrind -q --leak-check=yes --log-file=valgrind_leak.log --error-exitcode=42"  ;;
        c) echo "Compilation on"
            compile=1 ;;
    esac
done

if [ $compile -eq 1 ]; then
    $COMPILATOR -g $NC_PROGRAM_MY || { echo "Compilation failed aborting"; exit 1; }
fi

# radnom or pub mode based on the given flag
# in a pub mode it compares the reference solution and mine and stops when they differ
if [ $random_mode -eq 1 ]; then
    mkdir -p my_random_data
    for i in `seq 1 100`
    do
        PROBLEM=my_random_data/hw$HW
        MY_SOLUTION=my_random_data/my_hw$HW
        # generate random input
        $PROGRAM_REF -generate > $PROBLEM.in 2>/dev/null
        
        # get their solution to the problem
        $PROGRAM_REF < $PROBLEM.in > $PROBLEM.out 2>$PROBLEM.err

        start_time=$(date +%s%3N) #start timer
        # get my solution to the problem
        $valgrind $PROGRAM_MY < $PROBLEM.in > $MY_SOLUTION.out 2>$MY_SOLUTION.err
        
        valgrind_status=$?            
        end_time=$(date +%s%3N) # end timer
        run_time=$(($end_time - $start_time)) # final time
        
        # check valgrind error
        if [ "$valgrind_status" -eq 42 ]; then
            printf "\n Random test $i memory leak detected:"
            cat valgrind_leak.log # show the valgrind error (it is put away to its own file to not collide with stderr)
            correct=0
        fi

        # compare the solutions normally and print the outcome
        diff $MY_SOLUTION.out $PROBLEM.out && diff $MY_SOLUTION.err $PROBLEM.err
        if [ $? -eq 0 ]; then
            echo "Random test $i is correct (${run_time}ms)"
        else
            printf "\n Random test $i is not correct\n"
            correct=0
        fi

        # if -x compare the solutions also in the hex form
        if [ $hex_mode -eq 1 ] && [ $correct -eq 0 ]; then
            hexdump -C $MY_SOLUTION.out > $MY_SOLUTION.out.hex
            hexdump -C $PROBLEM.out > $PROBLEM.out.hex

            diff $MY_SOLUTION.out.hex $PROBLEM.out.hex
        fi

        # stop at an incorrect solution
        if [ $correct -eq 0 ]; then
            break
        fi

    done

else
    add=0 # 0 for numbers smaller than 10
    mkdir -p my_data
    for i in `seq 1 20`
    do
        if [ $i -eq 10 ]; then
            add="" # number is two-digit so omit the zero infront
        fi

        # do this only if the file with the corresponding name exists
        if test -f data/pub$add$i.in; then
            PROBLEM=data/pub$add$i # where are the reference data saved
            MY_SOLUTION_OUT=my_data/my_pub$add$i.out # where I want my solutions to be saved
            
            
            start_time=$(date +%s%3N) #start timer
            # run my program
            $valgrind $PROGRAM_MY < $PROBLEM.in > $MY_SOLUTION_OUT
            valgrind_status=$?
            end_time=$(date +%s%3N) # end timer
            run_time=$(($end_time - $start_time)) # final time


            # check valgrind error           
            if [ "$valgrind_status" -eq 42 ]; then
                printf "\n Pub test $i memory leak detected:"
                cat valgrind_leak.log # show the valgrind error
                correct=0
            fi

            # compare my solution with theirs and print the outcome
            diff $MY_SOLUTION_OUT $PROBLEM.out
            if [ $? -eq 0 ]; then
                echo "Pub test $i is correct (${run_time}ms)"
            else
                printf "\n Pub test $i is not correct\n"
                correct=0
            fi

            # if -x compare it also in the hex form
            if [ $hex_mode -eq 1 ] && [ $correct -eq 0 ]; then
                hexdump -C $MY_SOLUTION_OUT > $MY_SOLUTION_OUT.hex

                if !(test -f $PROBLEM.out.hex); then
                    hexdump -C $PROBLEM.out > $PROBLEM.out.hex
                fi

                diff $MY_SOLUTION_OUT.hex $PROBLEM.out.hex

            fi

            # stop at an incorrect solution
            if [ $correct -eq 0 ]; then
                break
            fi
        fi
    done
fi

# Clean up the hidden Valgrind log
rm -f valgrind_leak.log
