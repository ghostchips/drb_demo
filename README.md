A simple exercise application I made to explore Ruby standard library's DRb. 

The app starts up a Pool and N number of workers each on a new thread. The Pool's purpose is to connect various clients with workers by giving out their URIs so that the client does not have to know it before hand. The workers don't do anything at this stage, as it is mainly an exercise to connect to a remote object via a DRb Server.

Once the Server is running after starting the app, below is a sample Client that can interact with the Server:

```ruby
require 'drb/drb'

class TestClient
  # need to include this to send the object to server
  include DRb::DRbUndumped

  attr_accessor :num

  def initialize(num)
    @num = num
  end
  
  def add
    num + num
  end
end

DRb.start_service('druby://127.0.0.1:9001')

# Reference PoolQueue object
pool = DRbObject.new_with_uri('druby://127.0.0.1:9000')

# gets next worker URI, put URI back on queue
worker_uri_1 = pool.next_worker_uri
worker_1 = DRbObject.new_with_uri(worker_uri_1)

worker_uri_2 = pool.next_worker_uri
worker_2 = DRbObject.new_with_uri(worker_uri_2)

# does not put retrieved URI back on queue
worker_uri_3 = pool.next_worker_uri!
worker_3 = DRbObject.new_with_uri(worker_uri_3)

client_object = TestClient.new(1)

# will compute in the Server Process
worker_1.perform(client_object, :add) # => 2

client_object.num = 2
worker_1.perform(client_object, :add) # => 4

client_object.num = 5
worker_2.perform(client_object, :add) # => 10

client_object.num = 10
worker_3.perform(client_object, :add) # => 20
```

The above works just fine running several clients on different terminal sessions on a local machine, without SSH. However when trying to do this across different machines via SSH the Server needs to know who the intended Client is to establish a connection. This means that when each worker server is started an end point has to be designated at that moment, limiting the intended usefulness of the application. 
