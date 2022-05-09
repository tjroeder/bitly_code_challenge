require 'rspec'
require_relative '../lib/bitlink'
require_relative '../lib/input_output'

RSpec.describe Bitlink do
  describe 'object' do
    let(:data) { 
                 { 
                   bitlink: 'http://bit.ly/2kkAHNs', 
                   user_agent: 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7', 
                   timestamp: '2021-02-15T00:00:00Z', 
                   referrer: 't.co', 
                   remote_ip: '4.14.247.63'
                 }
               }
    subject(:bitlink) { Bitlink.new(data) }

    it 'is an instance of a Bitlink' do
      expect(bitlink).to be_a(Bitlink)
    end

    it 'has a #uri attribute and data type' do
      expect(bitlink).to have_attributes(uri: URI('http://bit.ly/2kkAHNs'))
      expect(bitlink.uri).to be_a(URI::HTTP)
      expect(bitlink.uri.scheme).to eq('http')
      expect(bitlink.uri.host).to eq('bit.ly')
      expect(bitlink.uri.path).to eq('/2kkAHNs')
    end

    it 'has a #domain_hash attribute and data type' do
      expect(bitlink).to have_attributes(domain_hash: 'bit.ly/2kkAHNs')
      expect(bitlink.domain_hash).to be_a(String)
    end

    it 'has a #user_agent attribute and data type' do
      expect(bitlink).to have_attributes(user_agent: 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7')
      expect(bitlink.user_agent).to be_a(String)
    end

    it 'has a #timestamp attribute and data type' do
      expect(bitlink).to have_attributes(timestamp: DateTime.new(2021, 02, 15))
      expect(bitlink.timestamp).to be_a(DateTime)
    end

    it 'has a #referrer attribute and data type' do
      expect(bitlink).to have_attributes(referrer: 't.co')
      expect(bitlink.referrer).to be_a(String)
    end

    it 'has a #remote_ip attribute and data type' do
      expect(bitlink).to have_attributes(remote_ip: IPAddr.new('4.14.247.63'))
      expect(bitlink.remote_ip).to be_a(IPAddr)
    end
  end

  describe 'class methods' do
    let(:encode_path) { './spec/fixtures/encodes.csv' }
    let(:decode_path) { './spec/fixtures/decodes.json' }
    let!(:input_output) { 
      Bitlink.class_variable_set(:@@id_hashes, {})
      InputOutput.new(encode_path, decode_path, 2021) 
    }

    describe '.count_id_clicks_for_year' do
      context 'valid parameters' do
        it 'returns single count of clicks for valid domain, hash and year' do
          count = Bitlink.count_id_clicks_for_year('bit.ly', '2kJO0qS', 2021)
          expect(count).to eq(1)
        end

        it 'returns multiple count of clicks for valid domain, hash and year' do
          count = Bitlink.count_id_clicks_for_year('bit.ly', '2kkAHNs', 2021)
          expect(count).to eq(2)
        end
      end

      context 'invalid parameters' do
        it 'returns count of clicks for valid domain, hash and invalid year' do
          count = Bitlink.count_id_clicks_for_year('bit.ly', '2kkAHNs', 2000)
          expect(count).to eq(0)
        end
        
        it 'returns count of clicks for valid domain, invalid hash and year' do
          count = Bitlink.count_id_clicks_for_year('bit.ly', 'bad_hash', 2000)
          expect(count).to eq(0)
        end

        it 'returns count of clicks for valid domain and year, invalid hash' do
          count = Bitlink.count_id_clicks_for_year('bit.ly', 'bad_hash', 2021)
          expect(count).to eq(0)
        end

        it 'returns count of clicks for valid hash, invalid domain and year' do
          count = Bitlink.count_id_clicks_for_year('bad_dom', '2kkAHNs', 2000)
          expect(count).to eq(0)
        end

        it 'returns count of clicks for valid hash and year, invalid domain' do
          count = Bitlink.count_id_clicks_for_year('bad_dom', '2kkAHNs', 2021)
          expect(count).to eq(0)
        end

        it 'returns count of clicks for invalid domain, hash and year' do
          count = Bitlink.count_id_clicks_for_year('bad_dom', 'bad_hash', 2000)
          expect(count).to eq(0)
        end
      end
    end
  end
end
