require 'date'
require 'uri'
require 'ipaddr'

# Bitlink class with all link log information
class Bitlink
  attr_reader   :uri,
                :domain_hash,
                :user_agent,
                :timestamp,
                :referrer,
                :remote_ip
  @@id_hashes = {}

  def initialize(data)
    @uri             = URI(data[:bitlink])
    @domain_hash     = @uri.host + @uri.path
    @user_agent      = data[:user_agent]
    @timestamp       = DateTime.strptime(data[:timestamp])
    @referrer        = data[:referrer]
    @remote_ip       = IPAddr.new(data[:remote_ip])
    @@id_hashes[@domain_hash] ||= []
    @@id_hashes[@domain_hash] << self
  end

  # Return count of an id for a given year
  def self.count_id_clicks_for_year(domain, hash, year)
    sel_domain_hash = "#{domain}/#{hash}"

    return 0 unless @@id_hashes.key?(sel_domain_hash)
    @@id_hashes[sel_domain_hash].count { |log| log.timestamp.year == year }
  end
end
