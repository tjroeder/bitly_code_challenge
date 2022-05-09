require 'rspec'
require_relative '../lib/input_output'

RSpec.describe InputOutput do
  subject(:encode_path) { './spec/fixtures/encodes.csv' }
  subject(:decode_path) { './spec/fixtures/decodes.json' }
  subject(:io_valid_year) do
    Bitlink.class_variable_set(:@@id_hashes, {})
    InputOutput.new(encode_path, decode_path, 2021) 
  end

  subject(:io_invalid_year) do
    Bitlink.class_variable_set(:@@id_hashes, {})
    InputOutput.new(encode_path, decode_path, 1970) 
  end

  subject(:encode) { CSV.read(encode_path, headers: true, header_converters: :symbol) }
  subject(:decode) { JSON.parse(File.read(decode_path), symbolize_names: true) }

  describe 'object' do
    it 'is an instance of InputOutput' do
      expect(io_valid_year).to be_a(InputOutput)
    end

    it 'has an #encode attribute' do
      expect(io_valid_year).to have_attributes(encode: encode)
      expect(io_valid_year.encode).to be_a(CSV::Table)
    end

    it 'has an #decode attribute' do
      expect(io_valid_year).to have_attributes(decode: decode)
      expect(io_valid_year.decode).to be_a(Array)
    end

    it 'has an #year attribute' do
      expect(io_valid_year).to have_attributes(year: 2021)
      expect(io_valid_year.year).to be_a(Integer)
    end
  end

  describe 'instance methods' do
    describe '#read_csv' do
      it 'returns a CSV object' do
        expect(io_valid_year.read_csv(encode_path)).to be_a(CSV::Table)
      end
    end
    
    describe '#read_json' do
      it 'returns a Array' do
        expect(io_valid_year.read_json(decode_path)).to be_a(Array)
      end
    end

    describe '#bitlink_clicks_for_year' do
      context 'valid year given' do
        it 'returns an array' do
          expect(io_valid_year.bitlink_clicks_for_year).to be_a(Array)
        end

        it 'returns an array of hashes' do
          counts = io_valid_year.bitlink_clicks_for_year

          counts.each do |count|
            expect(count).to be_a(Hash)
          end
        end

        it 'returns expected counts of long urls' do
          expected = [
            { 'https://google.com/' => 0 },
            { 'https://github.com/' => 1 },
            { 'https://twitter.com/' => 2 }
          ]
          expect(io_valid_year.bitlink_clicks_for_year).to eq(expected)
        end
      end
        
      context 'invalid year given' do
        it 'returns an array' do
          expect(io_invalid_year.bitlink_clicks_for_year).to be_a(Array)
        end

        it 'returns an array of hashes' do
          counts = io_invalid_year.bitlink_clicks_for_year

          counts.each do |count|
            expect(count).to be_a(Hash)
          end
        end

        it 'returns expected counts of long urls' do
          expected = [
            { 'https://google.com/' => 0 },
            { 'https://github.com/' => 0 },
            { 'https://twitter.com/' => 0 }
          ]
          expect(io_invalid_year.bitlink_clicks_for_year).to eq(expected)
        end
      end
    end
  end
end
