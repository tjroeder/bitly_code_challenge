# Bitly Backend Engineer Code Challenge

## Table of Contents
- <a href="#problem-statement">Problem Statement</a>
- <a href="#task">Task</a>
- <a href="#versions-and-dependencies">Versions and Dependencies</a>
- <a href="#installation-guide">Installation Guide</a>
- <a href="#design-decisions">Design Decisions</a>


## Problem Statement
Calculate the number of clicks from 2021 for each record in the encode.csv data set.

## Task 
Create a program that can be run from the command line, and output the array of Bitlinks sorted in descending order by click count. The sorted array of JSON objects contain the long URL as the key and the click count as the value. 

### Output Format
```json
[{"LONG_URL": count}, {"LONG_URL": count}]
```
### Example Output Format
```json
[
  {
    "https://google.com": 3
  }, 
  {
    "https://www.twitter.com" : 2
  }
]
```
## Versions and Dependencies
- Ruby 2.7.2
- Bundler 2.2.27
### Gems/Standard Library Components Utilized
- CSV 3.2.3
- JSON 2.6.1
- OptParse 0.2.0
- RSpec 3.11.0
- URI 0.11.0

Full dependency list can be found in `Gemfile.lock`

Incompatabilities could occur if a different versions are used.
## Installation Guide
This install guide is for MacOS or other *nix systems.
1. Open your terminal, and navigate to directory of choice.
2. Clone this repository `$ git clone git@github.com:tjroeder/bitly_code_challenge.git`
3. Change directories to the newly cloned directory `$ cd bitly_code_challenge`
4. Verify that you have the correct version of Ruby, `$ ruby -v`. If you do not have the correct version of Ruby [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos) should be able to assist with installing just Ruby.
```shell
$ ruby -v
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [arm64-darwin20]
```
5. Verify that Bundler is installed `$ bundle -v`, if Bundler is not installed `$ gem install bundler`.
```shell
$ bundle -v
Bundler version 2.2.27
```
6. Run Bundler to install all dependencies `$ bundle`
```shell
$ bundle
Fetching gem metadata from https://rubygems.org/..
Resolving dependencies...
Using bundler 2.3.10
Fetching csv 3.2.3
Fetching optparse 0.2.0
Installing csv 3.2.3
Installing optparse 0.2.0
Bundle complete! 2 Gemfile dependencies, 3 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```
7. Run the application by using the Ruby command along with the `find_yearly_clicks.rb` file and three CL arguments and their respective options flag. The `-h` or `--help` flag can be used to display usage of all options flags. All option flags are required.
```shell
$ ruby ./lib/find_yearly_clicks.rb -h
Usage: find_yearly_clicks.rb [options]

        --encode_path PATH           Required CSV file path of encoded bitlinks to count
        --decode_path PATH           Required JSON file path of decoded bitlink logs
        --year YEAR                  Required four digit year to count yearly bitlinks

    -h, --help                       Show this message
```
8. To run the application and return the requested bitlink click count for 2021.
```shell
$ ruby ./lib/find_yearly_clicks.rb --encode_path ./data/encodes.csv --decode_path ./data/decodes.json --year 2021
```
### Bitlink Count Output to Console for 2021:
```json
[
  {
    "https://youtube.com/": 557
  },
  {
    "https://twitter.com/": 512
  },
  {
    "https://reddit.com/": 510
  },
  {
    "https://github.com/": 497
  },
  {
    "https://linkedin.com/": 496
  },
  {
    "https://google.com/": 492
  }
]
```

## Design Decisions
1. Built for readability, SRP, adaptability to change to different files encode, and decode files or years.
2. `Bitlink` class to hold all JSON object data as instances. The Bitlink class memoizes all Bitlinks by `domain/hash` for counting quickly.
3. `CliParser` class to verify all arguments are provided and to output an error if not. Also, verifies that the year is given in a four digit format.
4. `InputOutput` class for reading in encode and decode files, parsing and creating the Bitlink instances, and packaging the count for each link for the given year, than output to `STDOUT` as JSON.
5. `find_yearly_clicks` run file to accept the CL arguments, read and parse the files, create Bitlinks for storing file data, than return the calculated counts for each Bitlink for the given year. Also, will rescue from argument errors when they are missing, invalid format, or the directory/file doesn't exist than output to `STDERR`.
