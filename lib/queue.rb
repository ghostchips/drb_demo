require 'drb/drb'
require 'thread'

class UriQueue
  include DRb::DRbUndumped

  URI_ADDRESS = 'druby://localhost:8786'

  def initialize
    @queue = Queue.new
    @mutex = Mutex.new
    @remove_uri = nil
  end

  def add_uri(uri)
    mutex.synchronize do
      queue << uri
    end
  end

  def remove_uri(uri)
    mutex.synchronize do
      @remove_uri = uri
    end
  end

  def next_uri
    mutex.synchronize do
      cycle_queue unless queue.size.zero?
    end
  end

  def queue_size
    queue.size
  end

  private

  attr_reader :queue, :mutex

  def cycle_queue
    next_uri =
      loop do
        uri = queue.shift
        break uri if uri != @remove_uri
      end
    @remove_uri = nil
    queue << next_uri
    next_uri
  end
end