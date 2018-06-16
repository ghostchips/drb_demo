require 'thread'
require_relative 'config'

threads = ::PROGRAMS.map do |(program_class, uri)|
  Thread.new do
    server = Server.new(program_class, uri)
    if program_class == PoolQueue
      server.start(::WORKER_URIS)
    else
      server.start
    end
  end
end

threads.each(&:join)
