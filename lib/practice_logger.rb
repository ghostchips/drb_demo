require 'drb/drb'

## LOGGER

SERVER_URI = 'druby://localhost:8787'

class Logger
  include DRb::DRbUndumped

  def initialize(n, fname)
    @name = n
    @filename = fname
  end

  def log(message)
    File.open(@filename, 'a') do |f|
      f.puts "#{Time.now}: #{@name}: #{message}"
    end
  end
end
