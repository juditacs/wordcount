# wordcount

Counting words in different programming languages.

# Format

All programs should read from STDIN and write to STDOUT. The input is always encoded in UTF-8.
The output should contain lines like this:

    freqword <tab> freq

## Example

    $ echo "apple pear apple art" | python2 wordcount.py
    apple   2
    art     1
    pear    1


## Test corpus: 100,000 German sentences

[de.gz](https://drive.google.com/file/d/0BzkofJIHAyZoRmhVM0lkZUNfZ2s/view?usp=sharing)

### Usage

    time zcat de.gz | python2 wordcount.py > python_out

## Javascript

Nodejs and npm are needed.
Install dependencies:

    cd javascript
    npm install

Run:

    node index.js


## BASH

Set the LC\_COLLATE variable to C to consider non-alphanumeric characters when sorting:

    export LC_COLLATE=C

Run:

    time zcat de.gz | bash wordcount.sh > bash_out
