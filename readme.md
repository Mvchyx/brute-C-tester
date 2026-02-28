# Brute C Offline Tester (`test_pubs.sh`)

It automatically tests your program against provided reference solutions using `diff`,
and checks memory leaks using `valgrind`, 
measures execution time in milliseconds, and stops at the first mistake found.

Works in POSIX or bash (tested in vs code terminal)


> **DIRECTORY REQUIREMENT**
> This script **must** be located and executed directly inside the downloaded homework folder (`b3b36prg-hw??`) 
(alongside `main.c` or compiled `a.out` file)

## Installation

Before running the script for the first time, you need to make it executable: `chmod +x test_pubs.sh`
Valgrind has to be downloaded (If valgrind is to be used): `sudo apt install valgrind`

## Arguments & Flags

* **`-r` (Random Mode):** Uses the reference generator to create random inputs. If all tests pass, it automatically runs 100 iterations. Data is saved in the `my_random_data` folder.

* **`-x` (Hex Dump):** If an output mismatch occurs, it generates `.hex` files and prints a hex dump comparison.

* **`-c` (Compile):** Automatically compiles `main.c` using `gcc` with the `-g` debugging flag included. Stops execution immediately if compilation fails.

* **`-v` (Valgrind Check):** Runs a silent Valgrind memory leak check. Only prints an error report if a memory leak or invalid read/write is detected.

* **`-d` (Entire dump):** If an output mismatch occurs, along with the differences also prints the entire output files.

* **`-3` (Custom input for HW03):** Tets your solution against theirs with your custom input. It asks for the three values.

## Usage Examples

**Basic Pub Test:**
Run against the standard reference `pub??` files in the `data` folder:

    ./test_pubs.sh

**Random Input Test:**
Run 100 iterations against randomly generated inputs:

    ./test_pubs.sh -r

**The Ultimate Validation:**
Compile the code, run random inputs, check for memory leaks, and print hex dumps if anything fails:

    ./test_pubs.sh -rcvx

## Output Features
* **Execution Profiling:** Every successful test prints the exact C program execution time in milliseconds (e.g., `Pub test 01 is correct (3ms)`).
* **Fail-Fast:** The script intentionally halts on the very first failed test or memory leak, preventing terminal spam.
