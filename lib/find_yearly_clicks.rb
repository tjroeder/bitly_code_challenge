# Find Yearly Bitlink Clicks - Parse Bitlink logs and count the amount of clicks for a given year
require_relative './bitlink'
require_relative './cli_parser'
require_relative './input_output'

# File ingest encode CSV with Bitlinks to find click count for, decode JSON of Bitlink logs, parse data, create bitlinks, calculate total counts of Bitlink clicks, and print answer array to STDOUT. Should any errors occur print to STDERR.

begin
  # Create new CLI parser to receive path arguments
  parser = CliParser.new
  parser.define_options(ARGV)

  # Pass CLI arguments, parse data, create bitlinks instances, calculate bitlink counts, output sorted bitlink counts to STDOUT.
  opt = parser.options
  bitlinks = InputOutput.new(opt[:encode_path], opt[:decode_path], opt[:year])
  sorted_counts = bitlinks.bitlink_clicks_for_year
  
  puts bitlinks.output_json(sorted_counts)

# Rescue from any missing argument, parse or file read/open errors
rescue OptionParser::MissingArgument => e
  puts %(OptionParser::MissingArgument: %s) % e.message
  exit
rescue OptionParser::ParseError => e
  puts %(OptionParser::ParseError: %s) % e.message
  exit
rescue Errno::ENOENT => e
  puts %(Errno::ENOENT: %s) % e.message
  exit
end
