require 'json'
require 'csv'

class FileIO
  attr_reader :encode, :decode

  def initialize(encode_path, decode_path)
    @encode = read_csv(encode_path)
    @decode = read_json(decode_path)
  end

  # Read the CSV and save as CSV object data
  def read_csv(path)
    CSV.read(path, headers: true, header_converters: :symbol)
  end
  
  # Read the JSON encode and save as Array object data
  def read_json(path)
    file = File.read(path)
    JSON.parse(file)
  end
end
