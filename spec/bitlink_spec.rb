require 'rspec'
require_relative '../lib/bitlink'
require_relative '../lib/file_io'

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

    it 'has a #url attribute and data type' do
      expect(bitlink).to have_attributes(uri: URI('http://bit.ly/2kkAHNs'))
      expect(bitlink.uri).to be_a(URI::HTTP)
      expect(bitlink.uri.scheme).to eq('http')
      expect(bitlink.uri.host).to eq('bit.ly')
      expect(bitlink.uri.path).to eq('/2kkAHNs')
    end

    it 'has a #id attribute and data type' do
      expect(bitlink).to have_attributes(id: '2kkAHNs')
      expect(bitlink.id).to be_a(String)
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
    let(:bitlink_files) { FileIO.new(encode_path, decode_path) }
    let!(:bitlinks) do 
      Bitlink.class_variable_set(:@@id_hashes, {})
      bitlink_files.decode.map { |data| Bitlink.new(data) }
    end
    
    describe '.id_hashes' do
      it 'returns a class variable and hash data type' do
        expect(Bitlink.id_hashes).to be_a(Hash)  
        expect(Bitlink.id_hashes.count).to eq(3)
        expect(Bitlink.id_hashes.keys).to eq(['2kkAHNs', '2kJO0qS', '3MgVNnZ'])
        expect(Bitlink.id_hashes['2kkAHNs'].count).to eq(2)
        expect(Bitlink.id_hashes['2kJO0qS'].count).to eq(1)
        expect(Bitlink.id_hashes['3MgVNnZ'].count).to eq(1)
      end

      it 'does not return a id if there are no Bitlinks' do
        expect(Bitlink.id_hashes.include?('no_id')).to eq(false)
      end
    end
    
    describe '.count_id_clicks_for_year' do
      it 'returns a count of clicks for a valid id and year' do
        expect(Bitlink.count_id_clicks_for_year('2kkAHNs', 2021)).to eq(1)
      end
      
      it 'returns a count of clicks for a valid id and non valid year' do
        expect(Bitlink.count_id_clicks_for_year('2kkAHNs', 2000)).to eq(0)
      end
      
      it 'returns a count of clicks for a non valid id and valid year' do
        expect(Bitlink.count_id_clicks_for_year('no_id_here', 2021)).to eq(0)
      end

      it 'returns a count of clicks for a non valid id and year' do
        expect(Bitlink.count_id_clicks_for_year('no_id_here', 2000)).to eq(0)
      end
    end
  end
end