require 'thread'
require 'drb/drb'
require 'drb/acl'
require 'dotenv/load'
require 'net/ssh'

require_relative 'lib/server'
require_relative 'lib/pool_queue'
require_relative 'lib/worker'

$SAFE = 1

WORKERS = 3
WORKERS_CLASS = Worker
IP_CREDENTIALS = [ENV['IP_CONNECT'], ENV['IP_USERNAME'], ENV['IP_PASSWORD']]

POOL_URI = (ip = 'druby://127.0.0.1:') + (port = '9001')
END_PORT = (port.to_i + WORKERS).to_s

URIS = Array(POOL_URI..(ip + END_PORT))
WORKER_URIS = URIS[1..-1]

PROGRAMS = [
  [PoolQueue, POOL_URI, true]
]

WORKERS.times do |i|
  PROGRAMS << [WORKERS_CLASS, WORKER_URIS[i]]
end

