require 'drb/drb'
require 'thread'

class Server
  include DRb::DRbUndumped
  
  attr_reader :uri, :program_class
  
  def initialize(program_class, uri = nil)
    @uri = uri || DRb::DRbServer.new.uri
    @program_class = program_class
    puts "#{@program_class} Server initiated on #{@uri}"
  end

  def start(workers = nil)
    Socket.do_not_reverse_lookup = true
    class_args = [uri, workers].compact
    DRb.start_service(uri, program_class.new(*class_args))
    puts "#{program_class} server running on #{DRb.uri}"
    DRb.thread.join
  end

end
