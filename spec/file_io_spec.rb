require 'rspec'
require_relative '../lib/file_io'

RSpec.describe FileIO do
  subject(:encode_path) { './spec/fixtures/encodes.csv' }
  subject(:decode_path) { './spec/fixtures/decodes.json' }
  subject(:bitlink_files) { FileIO.new(encode_path, decode_path) }

  subject(:encode) { CSV.read(encode_path, headers: true, header_converters: :symbol) }
  subject(:decode) { JSON.parse(File.read(decode_path)) }

  describe 'object' do
    it 'is an instance of FileIO' do
      expect(bitlink_files).to be_a(FileIO)
    end

    it 'has an #encode attribute' do
      expect(bitlink_files).to have_attributes(encode: encode)
      expect(bitlink_files.encode).to be_a(CSV::Table)
    end

    it 'has an #decode attribute' do
      expect(bitlink_files).to have_attributes(decode: decode)
      expect(bitlink_files.decode).to be_a(Array)
    end
  end
end
