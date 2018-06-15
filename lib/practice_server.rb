require 'drb/drb'
require 'thread'

## SERVER
$SAFE = 1 # disable eval() and friends
URI = 'druby://localhost:8787'


class TimeServer
  include DRbUndumped

  def get_current_time
    mutex.synchronize do
      puts 'Thinking...'
      sleep(3)
      puts 'Done'
      Time.now
    end
  end

  private

  def mutex
    @mutex ||= Mutex.new
  end

end

FRONT_OBJECT = TimeServer.new

DRb.start_service(URI, FRONT_OBJECT)
puts DRb.uri
DRb.thread.join
