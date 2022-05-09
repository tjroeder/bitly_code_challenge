require 'date'
require 'uri'
require 'ipaddr'

class Bitlink
  attr_reader   :uri, 
                :id,
                :user_agent, 
                :timestamp, 
                :referrer, 
                :remote_ip
  @@id_hashes = {}

  def initialize(data)
    @uri             = URI(data[:bitlink])
    @id              = @uri.path.delete_prefix('/')
    @user_agent      = data[:user_agent]
    @timestamp       = DateTime.strptime(data[:timestamp])
    @referrer        = data[:referrer]
    @remote_ip       = IPAddr.new(data[:remote_ip])
    @@id_hashes[@id] ||= []
    @@id_hashes[@id] << self
  end

  # Return memoized bitlinks by id hashes
  def self.id_hashes
    @@id_hashes
  end

  # Return count of an id for a given year
  def self.count_id_clicks_for_year(id_hash, year)
    return 0 unless @@id_hashes.key?(id_hash)
    @@id_hashes[id_hash].count { |log| log.timestamp.year == year }
  end
end
