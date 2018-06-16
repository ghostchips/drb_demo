require_relative 'server'
require_relative 'pool_queue'
require_relative 'worker'

$SAFE = 1

WORKERS = 3
WORKERS_CLASS = Worker
POOL_URI = 'druby://localhost:8786'

WORKER_UIRS = []
WORKER_URIS = (
  POOL_URI.."druby://localhost:#{POOL_URI[-4..-1].to_i + WORKERS}"
).to_a[1..-1]

PROGRAMS = [
  [PoolQueue, POOL_URI]
]

WORKERS.times do |i|
  PROGRAMS << [WORKERS_CLASS, WORKER_URIS[i]]
end

