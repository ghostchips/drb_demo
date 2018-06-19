require_relative '../config'

class Server
  include DRb::DRbUndumped

  attr_reader :uri, :program_class, :acl

  def initialize(program_class, uri = nil)
    @uri = uri || DRb::DRbServer.new.uri
    @program_class = program_class
    @acl = ACL.new(%w[deny  all
                      allow 127.0.0.1
                      allow] << ENV['IP_CONNECT'])
    puts "#{@program_class} Server initiated on #{@uri}"
  end

  def start(workers = nil)
    Socket.do_not_reverse_lookup = true
    DRb.install_acl(acl)
    class_args = [uri, workers].compact
    DRb.start_service(uri, program_class.new(*class_args))
    puts "#{'-' * program_class.to_s.length}--------- running on #{DRb.uri}"
    DRb.thread.join
  end
end
