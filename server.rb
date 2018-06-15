require 'drb/drb'
require 'thread'

$SAFE = 1

class Server
  include DRb::DRbUndumped

  def self.start(server_class, uri = nil)
    Socket.do_not_reverse_lookup = true
    DRb.start_service(uri, server_class.new)
    puts "#{server_class} server running on #{DRb.uri}"
    DRb.thread.join
  end

end
