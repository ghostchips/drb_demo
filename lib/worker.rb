require_relative '../config'

class Worker
  include DRb::DRbUndumped

  def initialize(uri)
    @uri = uri
    @mutex = Mutex.new
  end

  def perform(object, method)
    mutex.synchronize do
      # not safe, I know. Don't have a real task to define so just letting the client define it for demo flexibility
      result = object.send(method)
      puts "Worker on #{uri} calling :#{method} on #{object} object => #{result}"
      result
    end
  end

  private
  attr_reader :uri, :mutex
end