require 'date'
require 'uri'

class Bitlink
  attr_reader :uri, 
              :user_agent, 
              :timestamp, 
              :referrer, 
              :remote_ip

  def initialize(data)
    @uri        = URI(data[:bitlink])
    @user_agent = data[:user_agent]
    @timestamp  = DateTime.strptime(data[:timestamp])
    @referrer   = data[:referrer]
    @remote_ip  = data[:remote_ip]
  end
end
