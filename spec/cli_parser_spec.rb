require_relative '../lib/cli_parser'

RSpec.describe CliParser do
  let(:encode_path) { './spec/fixtures/encodes.csv' }
  let(:decode_path) { './spec/fixtures/decodes.json' }
  let(:argv) { ['--encode_path', encode_path, '--decode_path', decode_path, '--year', '2000'] }

  subject(:cli_parser) { CliParser.new }
  
  describe 'object' do
    it 'is an instance of CliParser' do
      expect(cli_parser).to be_a(CliParser)
    end
    
    it 'has a #options attribute and data type' do
      expect(cli_parser).to have_attributes(options: {})
      expect(cli_parser.options).to be_a(Hash)
    end
  end
  
  describe 'class methods' do
    describe '#check_paths_and_year' do
      context 'valid paths' do     
        it 'returns no error if all argumnets are given' do
          cli_parser.options = { 
            encode_path: argv[1], 
            decode_path: argv[3], 
            year: argv[5] 
          }

          expect { cli_parser.check_paths_and_year }.not_to raise_error
        end
      end

      context 'invalid paths' do
        it 'returns MissingArgument Error if not given encode path' do
          cli_parser.options = { 
            decode_path: argv[3], 
            year: argv[5] 
          }

          expect { cli_parser.check_paths_and_year }.to raise_error(OptionParser::MissingArgument)
        end

        it 'returns MissingArgument Error if not given decode path' do
          cli_parser.options = { 
            encode_path: argv[1],
            year: argv[5] 
          }

          expect { cli_parser.check_paths_and_year }.to raise_error(OptionParser::MissingArgument)
        end

        it 'returns MissingArgument Error if not given year' do
          cli_parser.options = { 
            encode_path: argv[1],
            decode_path: argv[3]
          }

          expect { cli_parser.check_paths_and_year }.to raise_error(OptionParser::MissingArgument)
        end
      end
    end

    describe '#check_year_format' do
      context 'valid year format' do
        it 'returns no error if the year is in the correct format' do
          cli_parser.options = { 
            encode_path: argv[1], 
            decode_path: argv[3], 
            year: argv[5] 
          }

          expect { cli_parser.check_year_format }.not_to raise_error
        end

        it 'returns no error even if given year 0000' do
          cli_parser.options = { 
            encode_path: argv[1], 
            decode_path: argv[3], 
            year: '0000'
          }

          expect { cli_parser.check_year_format }.not_to raise_error
        end
      end

      context 'invalid year format' do
        it 'returns error if the year is in the incorrect four digit format' do
          cli_parser.options = { 
            encode_path: argv[1], 
            decode_path: argv[3], 
            year: '00'
          }

          expect { cli_parser.check_year_format }.to raise_error(OptionParser::InvalidArgument)
        end
      end
    end

    describe '#define_options' do
      context 'valid arguments' do
        it 'sets the options instance variable to a hash' do
          cli_parser.define_options(argv)

          expect(cli_parser.options).to be_a(Hash)
        end

        it 'sets the options hash with the key values given' do
          expected = { 
            encode_path: argv[1], 
            decode_path: argv[3], 
            year: argv[5] 
          }
          cli_parser.define_options(argv)

          expect(cli_parser.options).to eq(expected)
        end
      end
      
      context 'invalid arguments' do
        it 'does not set the options hash and raises error' do
          invalid_args = []
          
          expect { cli_parser.define_options(invalid_args) }.to raise_error(OptionParser::MissingArgument)
          expect(cli_parser.options).to eq({})
        end
      end
    end
  end
end
