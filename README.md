# wordcount

Counting words in different programming languages.

See the article on this project:
http://juditacs.github.io/2015/11/26/wordcount.html

or the follow-up article:
http://juditacs.github.io/2016/03/19/wordcount2.html

# Leaderboard

## Full Hungarian Wikipedia

Updated: March 30, 2016

Only the ones that finish are listed. The rest run out of memory.

| Rank | Experiment | CPU seconds | User time | Maximum memory | Contributor |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | rust/wordcount/wordcount | 154.86 | 148.16 | 6867252 | Joshua Holmer | 
| 2 | cpp/wordcount | 238.5 | 227.64 | 4373428 | Elliot Goodrich, Dmitry Andreev, Judit Acs | 
| 3 | cpp/wordcount_clang | 243.5 | 233.41 | 4373372 | Elliot Goodrich, Dmitry Andreev, Judit Acs | 
| 4 | d/wordcount | 250.99 | 238.54 | 6304604 | Pavel Chebotarev | 
| 5 | c/wordcount | 305.13 | 291.47 | 2423880 | gaebor | 
| 6 | python/wordcount_py2.py | 311.79 | 300.53 | 3894688 | Gabor Szabo | 
| 7 | go/bin/wordcount | 325.75 | 315.63 | 6085992 | David Siklosi | 
| 8 | php7.0 php/wordcount.php | 456.87 | 362.21 | 4111164 | Braun Patrik | 
| 9 | python/wordcount_py2_baseline.py | 511.12 | 490.27 | 8802472 | Judit Acs | 
| 10 | mono csharp/WordCount.exe | 733.7 | 560.38 | 4783840 | Tim Posey, Peter Szel | 
| 11 | perl/wordcount.pl | 778.48 | 758.74 | 7100124 | Larion Garaczi, Judit Acs | 
| 12 | python/wordcount_py3.py | 877.93 | 854.83 | 7672096 | Judit Acs | 
| 13 | php5.6 php/wordcount.php | 1051.85 | 940.92 | 12682668 | Braun Patrik | 
| 14 | lua lua/wordcount.lua | 1134.88 | 1029.69 | 7023604 | daurnimator | 
| 15 | julia julia/wordcount.jl | 1554.77 | 1519.4 | 7393432 | Attila Zseder, getzdan | 
| 16 | bash/wordcount.sh | 2463.07 | 2572.14 | 13772 | Judit Acs | 
| 17 | cpp/wordcount_baseline | 3239.05 | 3143.51 | 5965364 | Judit Acs | 

## 5 million lines from the Hungarian Wikipedia

Updated: March 28, 2016, 00:53 CET

| Rank | Experiment | CPU seconds | User time | Maximum memory | Contributor |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | rust/wordcount/wordcount | 21.23 | 20.28 | 990008 | Joshua Holmer | 
| 2 | d/wordcount | 31.09 | 29.72 | 752776 | Pavel Chebotarev | 
| 3 | cpp/wordcount | 41.98 | 39.92 | 775132 | Matias Fontanini, Judit Acs | 
| 4 | go/bin/wordcount | 42.15 | 40.28 | 859260 | David Siklosi | 
| 5 | python/wordcount_py2.py | 43.13 | 41.55 | 596396 | Gabor Szabo | 
| 6 | php7.0 php/wordcount.php | 53.85 | 39.34 | 709908 | Braun Patrik | 
| 7 | python/wordcount_py2_baseline.py | 71.46 | 69.34 | 1437328 | Judit Acs | 
| 8 | mono csharp/WordCountList.exe | 104.0 | 72.42 | 899168 | Peter Szel | 
| 9 | python/wordcount_py3.py | 110.37 | 107.15 | 1245036 | Judit Acs | 
| 10 | perl/wordcount.pl | 120.85 | 117.86 | 1242060 | Larion Garaczi, Judit Acs | 
| 11 | lua lua/wordcount.lua | 135.51 | 116.5 | 1210312 | daurnimator | 
| 12 | php5.6 php/wordcount.php | 136.31 | 118.12 | 2126484 | Braun Patrik | 
| 13 | java -classpath java WordCount | 143.01 | 128.67 | 1828536 | Dávid Márk Nemeskey | 
| 14 | julia julia/wordcount.jl | 149.2 | 147.09 | 2541028 | Attila Zseder, getzdan | 
| 15 | scala -J-Xmx2g -classpath scala Wordcount | 179.96 | 234.61 | 1423256 | Hans van den Bogert | 
| 16 | bash/wordcount.sh | 285.97 | 301.47 | 13612 | Judit Acs | 
| 17 | haskell/WordCount | 332.53 | 320.72 | 4217432 | Larion Garaczi | 
| 18 | cpp/wordcount_baseline | 362.35 | 344.3 | 983244 | Judit Acs | 
| 19 | elixir/wordcount | 397.52 | 387.1 | 2862204 | Norbert Melzer | 
| 20 | nodejs javascript/wordcount.js | 582.64 | 580.87 | 974596 | Laci Kundra | 
| 21 | nodejs typescript/wordcount.js | 636.28 | 609.03 | 921444 | Braun Patrik | 

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

## Test corpus: Hungarian Wikisource and Wikipedia

`scripts/create_input.sh` downloads and unpacks the latest Hungarian Wikisource XML dump.
Why Wikisource? It's not too small not too large and more importantly, it's valid utf8.
Why Hungarian? There are many non-ascii characters and the number of different word types is high.

`script/create_large_input.sh` downloads the unpacks the latest Hungarian Wikipedia.
This is the largest input used for comparison, see the first leaderboard.

### Usage

To test on a small sample:

    time cat data/huwikisource-latest-pages-meta-current.xml | head -10000 | python3 python/wordcount_py3.py > python_out

## Installation with Docker

I strongly recommend building the Docker image instead of installing every package manually, but it's possible to install the dependencies manually.
See the installation commands in `Dockerfile`.

## Docker image

You can run the experiment in a Docker container. 

Pull from DockerHub & tag it:

    docker pull svanoort/allthelanguages:latest && docker tag svanoort/allthelanguages:latest allthelanguages

If you wish to build locally (this while take quite a while):

    docker build -t allthelanguages --rm .

In either case, this requires quite a bit of storage, currently about 2.4 GB.

Run the image, mounting the local directory into the working directory of the docker file as a volume:

    docker run -h DOCKER -it --rm -v $(pwd):/allthelanguages allthelanguages as_user.sh $(id -un) $(id -u) $(id -gn) $(id -g)

Changes you made in the folder will show up in the docker container, and any output (builds, results) will write to the folder as well. All permissions are maintained.

## Downloading the dataset

    bash scripts/create_input.sh

or the full dataset:

    bash scripts/create_large_input.sh

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

If all tests are passed, the scripts work reasonably well.
This does not mean that all output will be the same, see the full test later.
For now, we consider them good enough for testing.

This command will run each test twice and append the results to results.txt.
It's possible to add a comment at the end of each line.

    bash scripts/compare.sh data/huwikisource-latest-pages-meta-current.xml 2 "full huwikisource"

Or test it on a part of huwikisource:

    bash scripts/compare.sh <( head -10000 data/huwikisource-latest-pages-meta-current.xml) 1

Results.txt in a tab separated file that can be formatted to a Markdown table with this command:

    cat results.txt | python2 scripts/evaluate_results.py

This scripts prints the fastest run for each command in a markup table like this:

| Rank | Experiment | CPU seconds | User time | Maximum memory | Contributor |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | rust/wordcount/wordcount | 20.57 | 19.79 | 990008 | Joshua Holmer | 
| 2 | cpp/wc_vector | 33.3 | 31.93 | 775952 | Matias Fontanini, Judit Acs | 
| 3 | python/wordcount_py2gabor.py | 40.13 | 38.71 | 594800 | Gabor Szabo | 

## Adding a new program

Adding a new programming language or a new version for an existing programming language consists of the following steps:

1. Add dependencies to the Dockerfile. Basically add the package to the existing apt-get package list.
2. If it needs compiling or any other setup method, add it to `scripts/build.sh`
3. Add the actual invoke command to `run_commands.txt`
4. If your executable differs from the source file, add the executable - source code mapping to `binary_mapping.txt`. This is used by `scripts/evaluate_results.py` for finding out the contributors of each program. The file is <b>tab-separated</b>.

### Adding your program to this experiment

1. Make sure all dependencies are installed via standard packages and your code compiles.
1. Your code passes all the tests.
1. Make sure it runs for less than two minutes for 100,000 lines of text. If it is slower, it doesn't make much sense to add it.

