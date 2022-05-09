require 'rspec'
require_relative '../lib/bitlink'

RSpec.describe Bitlink do
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

  describe 'object' do
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
      expect(bitlink).to have_attributes(remote_ip: '4.14.247.63')
      expect(bitlink.remote_ip).to be_a(String)
    end
  end
end