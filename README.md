# wordcount

Counting words in different programming languages.

See the article on this project:
http://juditacs.github.io/2015/11/26/wordcount.html

# Leaderboard

Updated: 07-12-2015 20:00

On 5 million lines from the Hungarian Wikipedia:

Notes:
* <b>New 2nd place, a clever Python implementation by @gaborszabo88</b>
* improved Perl, Julia and Javascript versions
* removed two C++ versions
* NodeJS runs out of memory (16GB is not enough) - fixed by @szelpe
* a faster C# (mono) version added by @szelpe
* Golang took over Python and is now 2nd place - congrats @siklosid
* Haskell version by @larion
* further test are run only on the Hungarian Wikipedia, the other tables are deprecated

| Rank | Experiment | CPU seconds | User time | Maximum memory | Contributor |
| :---: | :---: | :---: | :---: | :---: | :--: |
| 1 | cpp/wc_vector | 34.21 | 32.73 | 772048 | @juditacs |
| 2 | python/wordcount_py2gabor.py | 36.93 | 35.69 | 596792 | @gaborszabo88 |
| 3 | go/bin/wordcount | 40.92 | 39.37 | 856128 | @siklosid |
| 4 | python/wordcount_py2.py | 66.65 | 64.68 | 1433152 | @juditacs |
| 5 | java -classpath java WordCount | 79.92 | 68.17 | 1799236 | @DavidNemeskey |
| 6 | cpp/wc_baseline_hash | 85.8 | 70.14 | 971720 | @juditacs |
| 7 | mono csharp/WordCountList.exe | 100.69 | 71.01 | 900496 | @szelpe |
| 8 | perl/wordcount.pl | 103.82 | 101.63 | 1237776 | @larion |
| 9 | python/wordcount_py3.py | 105.08 | 102.45 | 1241144 | @juditacs |
| 10 | php php/wordcount.php | 135.94 | 118.29 | 2119284 | @bpatrik |
| 11 | julia julia/wordcount.jl | 143.81 | 140.8 | 2558176 | @getzdan |
| 12 | bash/wordcount.sh | 280.79 | 287.16 | 11564 | @juditacs |
| 13 | haskell/WordCount | 290.53 | 285.36 | 4208920 | @larion |
| 14 | nodejs javascript/wordcount.js | 702.88 | 701.76 | 985500 | @kundralaci |


On the full Hungarian Wikipedia:

TBA

# The task

The task is to split a text and count each word's frequency, then print the list sorted by frequency in decreasing order.
Ties are printed in alphabetical order.

## Rules

* the input is read from STDIN
* the input is always encoded in UTF-8
* output is printed to STDOUT
* break only on space, tab and newline (do not break on non-breaking space)
* do not write anything to STDERR
* the output is tab-separated
* sort by frequency AND secondary sort in alphabetical order
* try to write simple code with few dependencies
  * standard library
* single-thread is preferred but you can add multi-threaded or multicore versions too


The output should contain lines like this:

    freqword <tab> freq

## Example

    $ echo "apple pear apple art" | python2 python/wordcount.py
    apple   2
    art     1
    pear    1

## Test corpus: Hungarian Wikisource

`scripts/create_input.sh` downloads the latest Hungarian Wikisource XML dump.
Why Wikisource? It's not too small not too large and more importantly, it's valid utf8.
Why Hungarian? There are many non-ascii characters and the number of different word types is high.


### Usage

To test on a small sample:

    time cat data/huwikisource-latest-pages-meta-current.xml | head -10000 | python3 python/wordcount_py3.py > python_out

## Installation

There are two ways to install all the dependencies:

1. Build a Docker image with the provided Dockerfile, which installs all the required packages.
2. Install them manually via a package manager. The Docker image is an Ubuntu image but the same packages work for me on Manjaro Linux as well. Use this command on Ubuntu to install all dependencies, but be prepared for a lot of new packages. You've been warned.
    
    sudo apt-get install wget gcc python npm perl php5 git default-jdk time


## Docker image

You can run the experiment in a Docker container. The Dockerfile is provided, run:

    docker build -t wordcount --rm .

This might take a while.

Load the image into a container:

    docker run -it wordcount bash

You should see the cloned directory in `/root`

    cd wordcount


## Downloading the dataset

    bash scripts/create_input.sh

## Compile/build/whatever the wordcount scripts

    bash scripts/build.sh

## Run tests on one language

`scripts/test.sh` runs all tests for one language, well actually for a single command.

    bash scripts/test.sh "python2 python/wordcount_py2.py"

Or

    bash scripts/test.sh python/wordcount_py2.py

if the file is executable and has a valid shebang line.

The script either prints OK or the list of failed tests and a final FAIL.

## Run tests on all languages

All commands are listed in the file `run_commands.txt` and the script `scripts/test_all.sh` runs test.sh with each command:

    bash scripts/test_all.sh

## Run the actual experiment on a larger dataset

If all tests are passed, the scripts work reasonably well. This does not mean that all output will be the same, see the full test later.
For now, we consider them good enough for testing.

This command will run each test twice and save the results to results.txt.

    bash scripts/compare.sh data/huwikisource-latest-pages-meta-current.xml 2

Or test it on a part of huwikisource:

    bash scripts/compare.sh <( head -10000 data/huwikisource-latest-pages-meta-current.xml) 1

Results.txt in a tab separated file that can be formatted to a Markdown table with this command:

    cat results.txt | python2 scripts/evaluate_results.py

This scripts prints the fastest run for each command in a markup table like this:

| Experiment | CPU seconds | User time | Maximum memory |
| --- | --- | --- | --- |
| cpp/wc_vector | 2.68 | 2.37 | 32168 |
| python/wordcount_py2.py | 2.68 | 2.61 | 71512 |
| bash/wordcount.sh | 3.0 | 4.19 | 10820 |

## Adding a new program

Adding a new programming language or a new version for an existing programming language consists of three steps:

1. add dependencies to the Dockerfile. Basically add the package to the existing apt-get package list.
2. if it needs compiling or any other setup method, add it to `scripts/build.sh`
3. add the actual invoke command to `run_commands.txt`

### Adding your program to this experiment

1. Make sure all dependencies are installed via standard packages and your code compiles.
1. Your code passes all the tests.
1. Make sure it runs for less than two minutes for 100,000 lines of text. If it is slower, it doesn't make much sense to add it.

