require 'optparse'

# CLI Parser for parsing command line arguments. 
class CliParser
  attr_accessor :options

  def initialize
    @options = {}
  end

  # Parse, check and define for given ARGV file path arguments
  def define_options(args)
    OptionParser.new do |opts|
      opts.banner = "Usage: find_yearly_clicks.rb [options]"
      opts.separator ''
    
      opts.on('--encode_path PATH', String, 
              'Required CSV file path of encoded bitlinks to count') do |path|
        @options[:encode_path] = path
      end
    
      opts.on('--decode_path PATH', String, 
              'Required JSON file path of decoded bitlink logs') do |path|
        @options[:decode_path] = path
      end

      opts.on('--year YEAR', String, 
              'Required four digit year to count yearly bitlinks') do |year|
        @options[:year] = year
      end
    
      opts.separator ''
    
      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end.parse!(args)
    check_paths_and_year
    check_year_format
  end

  # Check that required filepaths and year are given
  def check_paths_and_year
    path_options = { 
                     encode_path: '--encode_path', 
                     decode_path: '--decode_path',
                     year: '--year'
                   }
    errors = []
    errors << path_options[:encode_path] if @options[:encode_path].nil?
    errors << path_options[:decode_path] if @options[:decode_path].nil?
    errors << path_options[:year] if @options[:year].nil?

    raise OptionParser::MissingArgument.new(errors) if errors.count.positive?
  end
  
  # Check the year is given in a four digit format
  def check_year_format
    path_options = { 
                     year: '--year'
                   }
    year_error = path_options[:year] unless @options[:year].size == 4
  
    raise OptionParser::InvalidArgument.new(year_error) if year_error
  end
end
