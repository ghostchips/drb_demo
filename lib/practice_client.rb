require 'drb/drb'

# CLIENT

SERVER_URI = 'druby://localhost:8786'
SERVER_URI = 'druby://localhost:8787'

DRb.start_service

server = DRbObject.new_with_uri('druby://localhost:8786')
server2 = DRbObject.new_with_uri(SERVER_URI)
timeserver.get_current_time
%w[druby://localhost:8788 druby://localhost:8789 druby://localhost:8790].each do |uri|
  server.add_uri(uri)
end
%w[druby://localhost:8791 druby://localhost:8792 druby://localhost:8793].each do |uri|
  server2.add_uri(uri)
end
