require_relative 'config'

channel_ready = Queue.new
threads = PROGRAMS.map do |(program_class, uri, is_pool)|
  Thread.new do
    server = Server.new(program_class, uri)
    is_pool ? server.start(WORKER_URIS) : server.start

    Net::SSH.start(*IP_CREDENTIALS) do |session|
      session.forward.local(9001, '127.0.0.1', 9001)
      session.forward.remote(9000, '127.0.0.1', 9000)

      session.open_channel do |channel| end
      channel_ready << true
      session.loop
    end
  end
end

threads.each(&:join) if channel_ready.pop
