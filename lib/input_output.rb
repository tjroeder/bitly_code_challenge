require 'json'
require 'csv'
require_relative './bitlink'

class InputOutput
  attr_reader :encode, 
              :decode, 
              :year, 
              :bitlinks

  def initialize(encode_path, decode_path, year)
    @encode = read_csv(encode_path)
    @decode = read_json(decode_path)
    @year = year
    @bitlinks = @decode.map { |data| Bitlink.new(data) }
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

  # Return array of bitlink clicks for the given year,and  encode, decode files
  def bitlink_clicks_for_year
    @encode.map do |link|
      count = Bitlink.count_id_clicks_for_year(link[:domain], link[:hash], year)
      { link[:long_url] => count }
    end
  end
end


