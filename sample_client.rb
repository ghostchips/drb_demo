require 'drb/drb'

class Test
  # need to include this to send the object to server
  include DRb::DRbUndumped

  attr_accessor :num
  
  def initialize(num); @num = num; end
  def add; num + num; end
end

DRb.start_service

# Reference PoolQueue object
pool = DRbObject.new_with_uri('druby://localhost:8786')

# gets next worker uri, put uri back on queue
worker_uri_1 = pool.next_worker_uri
worker_1 = DRbObject.new_with_uri(worker_uri_1)

worker_uri_2 = pool.next_worker_uri
worker_2 = DRbObject.new_with_uri(worker_uri_2)

# does not put retrived uri back on queue
worker_uri_3 = pool.next_worker_uri!
worker_3 = DRbObject.new_with_uri(worker_uri_3)

object = Test.new(1)

# will compute in the Server Process
worker_1.perform(object, :add) # => 2

object.num = 2
worker_1.perform(object, :add) # => 4

object.num = 5
worker_2.perform(object, :add) # => 10

object.num = 10
worker_3.perform(object, :add) # => 20
