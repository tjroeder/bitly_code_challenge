# Bitly Backend Engineer Code Challenge

## Table of Contents
- <a href="#problem-statement">Problem Statement</a>
- <a href="#task">Task</a>
- <a href="#versions-and-dependencies">Versions and Dependencies</a>
- <a href="#installation-guide">Installation Guide</a>
- <a href="#code-challenge-answer">Code Challenge Answer</a>
- <a href="#design-decisions">Design Decisions</a>

## Problem Statement
Calculate the number of clicks from 2021 for each record in the encode.csv data set.

## Task 
Create a program that can be run from the command line, and output the array of Bitlinks sorted in descending order by click count. The sorted array of JSON objects contain the long URL as the key and the click count as the value. 

<details>
<summary>Output Format</summary>

```json
[{"LONG_URL": count}, {"LONG_URL": count}]
```
</details>

<details>
<summary>Example Output Format</summary>

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
</details>

## Versions and Dependencies
- `Ruby 2.7.2`
- `Bundler 2.2.27`

### Gems/Standard Library Components Utilized
- `CSV 3.2.3`
- `JSON 2.6.1`
- `OptParse 0.2.0`
- `RSpec 3.11.0`
- `URI 0.11.0`

Full dependency list can be found in `Gemfile.lock`

Incompatabilities could occur if a different versions are used.

## Installation Guide
This install guide is for MacOS or other *nix systems.
1. Open your terminal, and navigate to directory of choice.
2. Clone this repository `$ git clone git@github.com:tjroeder/bitly_code_challenge.git`.
3. Change directories to the newly cloned directory `$ cd bitly_code_challenge`.
4. Verify that you have the correct version of Ruby, `$ ruby -v`. If you do not have the correct version of Ruby or it is not installed [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos) should be able to assist with installing/upgrading Ruby with Rbenv.

<details>
<summary>Terminal Example</summary>

```shell
$ ruby -v
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [arm64-darwin20]
```
</details>

5. Verify that Bundler is installed `$ bundle -v`, if Bundler is not installed `$ gem install bundler`.
<details>
<summary>Terminal Example</summary>

```shell
$ bundle -v
Bundler version 2.2.27
```
</details>

6. Run Bundler to install all dependencies `$ bundle`.
<details>
<summary>Terminal Example</summary>

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
</details>

7. Run the application by using the Ruby command along with the `find_yearly_clicks.rb` file and three CL arguments and their respective options flag. The `-h` or `--help` flag can be used to display usage of all options flags. All option flags are required.
<details>
<summary>Terminal Example</summary>

```shell
$ ruby ./lib/find_yearly_clicks.rb -h
Usage: find_yearly_clicks.rb [options]

        --encode_path PATH           Required CSV file path of encoded bitlinks to count
        --decode_path PATH           Required JSON file path of decoded bitlink logs
        --year YEAR                  Required four digit year to count yearly bitlinks

    -h, --help                       Show this message
```
</details>

8. To run all files in the RSpec testing suite `$ rspec`.
<details>
<summary>RSpec Output</summary>

```shell
Bitlink
  object
    is an instance of a Bitlink
    has a #uri attribute and data type
    has a #domain_hash attribute and data type
    has a #user_agent attribute and data type
    has a #timestamp attribute and data type
    has a #referrer attribute and data type
    has a #remote_ip attribute and data type
  class methods
    .count_id_clicks_for_year
      valid parameters
        returns single count of clicks for valid domain, hash and year
        returns multiple count of clicks for valid domain, hash and year
      invalid parameters
        returns count of clicks for valid domain, hash and invalid year
        returns count of clicks for valid domain, invalid hash and year
        returns count of clicks for valid domain and year, invalid hash
        returns count of clicks for valid hash, invalid domain and year
        returns count of clicks for valid hash and year, invalid domain
        returns count of clicks for invalid domain, hash and year

CliParser
  object
    is an instance of CliParser
    has a #options attribute and data type
  class methods
    #check_paths_and_year
      valid paths
        returns no error if all argumnets are given
      invalid paths
        returns MissingArgument Error if not given encode path
        returns MissingArgument Error if not given decode path
        returns MissingArgument Error if not given year
    #check_year_format
      valid year format
        returns no error if the year is in the correct format
        returns no error even if given year 0000
      invalid year format
        returns error if the year is in the incorrect four digit format
    #define_options
      valid arguments
        sets the options instance variable to a hash
        sets the options hash with the key values given
      invalid arguments
        does not set the options hash and raises error

InputOutput
  object
    is an instance of InputOutput
    has an #encode attribute and data type
    has an #decode attribute and data type
    has an #year attribute and data type
  instance methods
    #read_csv
      returns a CSV object
    #read_json
      returns a Array
    #create_bitlinks
      returns an array
      returns an array of bitlink objects
    #bitlink_clicks_for_year
      valid year given
        returns an array
        returns an array of hashes
        returns expected counts of long urls
      invalid year given
        returns an array
        returns an array of hashes
        returns expected counts of long urls
    #output_json
      returns JSON String data

Finished in 0.01447 seconds (files took 0.33795 seconds to load)
42 examples, 0 failures
```
</details>

9. To run the application and return the requested bitlink click count for 2021.
<details>
<summary>Terminal Example</summary>

```shell
$ ruby ./lib/find_yearly_clicks.rb --encode_path ./data/encodes.csv --decode_path ./data/decodes.json --year 2021
```
</details>

## Code Challenge Answer
Bitlink Count Output to Console for 2021.

<details>
<summary>Reveal Code Challenge Answer</summary>

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
</details>

## Design Decisions
1. Built for readability, SRP, adaptability to change to different files encode, and decode files or years.
2. `Bitlink` class to hold all JSON object data as instances. The Bitlink class memoizes all Bitlinks by `domain/hash` for counting quickly.
3. `CliParser` class to verify all arguments are provided and to output an error if not. Also, verifies that the year is given in a four digit format.
4. `InputOutput` class for reading in encode and decode files, parsing and creating the Bitlink instances, and packaging the count for each link for the given year, than output to `STDOUT` as JSON.
5. `find_yearly_clicks` run file to accept the CL arguments, read and parse the files, create Bitlinks for storing file data, than return the calculated counts for each Bitlink for the given year. Also, will rescue from argument errors when they are missing, invalid format, or the directory/file doesn't exist than output to `STDERR`.
