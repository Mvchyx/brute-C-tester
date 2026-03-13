# Brute C Offline Tester (`test_pubs.sh`)

It automatically tests your program against provided reference solutions using `diff`,
and checks memory leaks using `valgrind`, 
measures execution time in milliseconds, and stops at the first mistake found.

Works in POSIX or bash (tested in vs code terminal)


> **DIRECTORY REQUIREMENT**
> This script **must** be located and executed directly inside the downloaded homework folder (`b3b36prg-hw??`) 
(alongside `main.c` or compiled `a.out` file)
The script will automatically search upwards in the directory tree to find its configuration files (`init_config.sh` and `default_settings.json`).

## Installation

Before running the script for the first time, you need to make it executable: `chmod +x test_pubs.sh`
Valgrind has to be downloaded (If valgrind is to be used): `sudo apt install valgrind`

## Arguments & Flags

-r (Random Mode): Uses the reference generator to create random inputs. If all tests pass, it runs the default number of iterations defined in your JSON settings. Data is saved in the my_random_data folder.

* **`-r` (Random Mode):** Uses the reference generator to create random inputs. If all tests pass, it runs the number of iterations defined in your JSON settings (default is 30). Data is saved in the `my_random_data` folder.

* **`-R <number>` (Custom Random Mode):** Lets you input a custom number of random test iterations (e.g., -R 500).

* **`-x` (Hex Dump):** If an output mismatch occurs, it generates `.hex` files and prints a hex dump comparison.

* **`-c` (Compile):** Automatically compiles `main.c` using compiler defines in the json file (`gcc` set as default) with the `-g` debugging flag included. Stops execution immediately if compilation fails.

* **`-v` (Valgrind Check):** Runs a silent Valgrind memory leak check. Only prints an error report if a memory leak or invalid read/write is detected.

* **`-d` (Entire dump):** If an output mismatch occurs, along with the differences also prints the entire output files.

* **`-i` (Manual input):** Tets your solution against theirs with your custom input.

* **`-s` (Standard Diff):** Disables the default side-by-side output for diff.

## Usage Examples

**Basic Pub Test:**
Run against the standard reference `pub??` files in the `data` folder:

    ./test_pubs.sh

**Random Input Test:**
Run 100 iterations against randomly generated inputs:

    ./test_pubs.sh -r

**The Ultimate Validation:**
Compile the code, run 1000 random inputs, check for memory leaks, and print hex dumps if anything fails:

    ./test_pubs.sh -cvxR 1000

## Output Features
* **Execution Profiling:** Every successful test prints the exact C program execution time in milliseconds (e.g., `Pub test 01 is correct (3ms)`).
* **Fail-Fast:** The script intentionally halts on the very first failed test or memory leak, preventing terminal spam.

## It reads configuration from two files:
1. **`default_settings.json`**: The base configuration containing standard values (like `gcc`, `main.c`, and default loop counts). This file should be committed to your repository.
2. **`user_settings.json`**: An optional local file used to override the defaults. **You should add `user_settings.json` to your `.gitignore` file.**

### Customizing Your Setup
If you want to change how the script behaves without modifying the code (for example, if you prefer `clang` over `gcc`, or want 100 default loops instead of 30), just use `user_settings.json` in the same folder as `default_settings.json` e.g.:

```json
{
  "compilator": "clang",
  "default_loops": 100
}
