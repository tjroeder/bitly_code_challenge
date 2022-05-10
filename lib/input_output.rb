require 'json'
require 'csv'
require_relative './bitlink'

# Input Output class for parsing encode CSV, decode JSON, create Bitlink instances, generate sorted JSON of Bitlink counts for given year
class InputOutput
  attr_reader :encode, 
              :decode, 
              :year, 
              :bitlinks

  def initialize(encode_path, decode_path, year)
    @encode = read_csv(encode_path)
    @decode = read_json(decode_path)
    @year = year.to_i
    create_bitlinks
  end

  # Read the CSV and return as CSV object data
  def read_csv(path)
    CSV.read(path, headers: true, header_converters: :symbol)
  end
  
  # Read the JSON encode and return as Array object data
  def read_json(path)
    file = File.read(path)
    JSON.parse(file, symbolize_names: true)
  end

  # Create Bitlink instances from the decode logs
  def create_bitlinks
    @decode.map { |data| Bitlink.new(data) }
  end

  # Return sorted array of bitlink clicks for the given year,and encode, decode files
  def bitlink_clicks_for_year
    array = @encode.map do |link|
      count = Bitlink.count_id_clicks_for_year(link[:domain], link[:hash], @year)
      { link[:long_url] => count }
    end
    array.sort_by(&:values).reverse
  end

  # Return a JSON string in pretty print format
  def output_json(array)
    JSON.pretty_generate(array)
  end
end


