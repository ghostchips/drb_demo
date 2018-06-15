require 'thread'
require_relative 'server'
require_relative 'lib/queue'
require_relative 'lib/worker'

PROGRAMS = [
  Worker,
  [UriQueue, UriQueue::URI_ADDRESS]
]

URIS = []

  threads = PROGRAMS.map do |(klass, uri)|
    Thread.new do
      Server.start(klass, uri)
    end
  end

threads.each(&:join)