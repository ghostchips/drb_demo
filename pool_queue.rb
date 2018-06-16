require 'drb/drb'
require 'thread'

class PoolQueue
  include DRb::DRbUndumped

  def initialize(uri, worker_uris = [])
    @queue = Queue.new
    @mutex = Mutex.new
    @uri = uri
    @remove_uri = nil
    add_uris(worker_uris) unless worker_uris.empty?
  end
  
  def uri
    @uri
  end

  # here if maybe there's a way to check if a dbr process is dead?
  def remove_uri(uri)
    mutex.synchronize do
      @remove_uri = uri
    end
  end
    
  def next_worker_uri
    cycle_queue unless queue.size.zero?
  end
  
  def next_worker_uri!
    cycle_queue(true) unless queue.size.zero?
  end
  
  private
  attr_reader :queue, :mutex
  
  def add_uris(uris)
    uris.each do |uri| 
      mutex.synchronize { queue << uri }
    end
  end
  
  def cycle_queue(destructive = false)
    next_uri =
      loop do
        uri = queue.shift
        # removes unwanted uri on cycle
        break uri if uri != @remove_uri
      end
    @remove_uri = nil
    queue << next_uri unless destructive
    next_uri
  end
end
